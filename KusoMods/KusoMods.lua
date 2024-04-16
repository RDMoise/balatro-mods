--- STEAMODDED HEADER
--- MOD_NAME: Kuso Modpack
--- MOD_ID: KusoMods
--- MOD_AUTHOR: [Kusoro]
--- MOD_DESCRIPTION: A collection of mods I've made. Mostly exists so that I can assign multiple custom deck images to custom decks.

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.KusoMods()
    local kuso_mod = SMODS.findModByID("KusoMods")
    local sprite_card = SMODS.Sprite:new("centers", kuso_mod.path, "Enhancers.png", 71, 95, "asset_atli") 
    sprite_card:register()
end

local Cardaddtodeck = Card.add_to_deck
function Card.add_to_deck(self)
	Cardaddtodeck(self)
	if self.ability.set == 'Joker' and G.GAME.starting_params.ksrflood then
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
			func = function()
			    local reditions = {{foil = true},{polychrome = true},{holo = true}}
			    if #G.jokers.cards == G.jokers.config.card_limit then return true end
				for i = 2, G.jokers.config.card_limit, 1 do
			    	card = copy_card(G.jokers.cards[1])
			        if card.edition ~= nil and card.edition.negative then card:set_edition(reditions[math.random(1, #reditions)]) end
                                card:add_to_deck()
                                G.jokers:emplace(card)
                                card:start_materialize()
                                G.GAME.joker_buffer = 0
			    end
			    return true
			end
		}))
        end
end

local Cardstartdissolve = Card.start_dissolve
function Card.start_dissolve(self)
	Cardstartdissolve(self)
	if self.ability.set == 'Joker' and G.GAME.starting_params.ksrflood then
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
			func = function()
			if #G.jokers.cards == 0 then return true end    
			    for i = #G.jokers.cards, 1, -1 do
				card = G.jokers.cards[i]
				card:start_dissolve()
				G.GAME.joker_buffer = 0
			    end
			    return true
			end
		}))
        end
end

local Drawcard = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	if G.GAME.starting_params.ksrcurse then G.SETTINGS.play_button_pos = math.random(1, 2) end
	if G.GAME.starting_params.ksrcurse and card and from == G.hand and to == G.discard then
        G.E_MANAGER:add_event(Event({trigger = 'before',delay = 1,
		func = function()
		local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix = card.base.id == 2 and 14 or math.max(card.base.id-1, 2)
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true
        end }))
    end
    Drawcard(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(self)
	Backapply_to_runRef(self)

	if self.effect.config.ksrcurse then
		G.GAME.starting_params.ksrcurse = self.effect.config.ksrcurse
	end

	if self.effect.config.ksrflood then 
		G.GAME.starting_params.ksrflood = self.effect.config.ksrflood 
	end

	if self.effect.config.ksrtwojokers then
		G.E_MANAGER:add_event(Event({
			func = function()
				for i = 1, 2 do
                            local card = nil
			    repeat   
				if card ~= nil then card:start_dissolve() end
				card = create_card('Joker', G.jokers)
			    until card.config.center.eternal_compat
			    card:set_eternal(true)
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            card:start_materialize()
                            G.GAME.joker_buffer = 0
                        end
				return true
			end
		}))
	end
end

local jkr_def = {
	["name"]="Joker Deck",
	["text"]={
		[1]="Start with two",
		[2]="random {C:attention}Eternal{} Jokers"
	},
}

local fld_def = {
	["name"]="Flood Deck",
	["text"]={
		[1]="{C:attention}One{} joker fills {C:attention}all{} slots,",
		[2]="Destroying {C:attention}one{} destroys {C:attention}all{}"
	},
}

local crs_def = {
	["name"]="Curse Deck",
	["text"]={
		[1]="Discarded cards",
		[2]="get {C:attention}downranked{} by 1,",
		[3]="{C:red}watch where you click{}"
	},
}

local jkrdeck = SMODS.Deck:new("Joker Deck", "ksrjkrdeck", {ksrtwojokers = true}, {x = 0, y = 5}, jkr_def)
local flddeck = SMODS.Deck:new("Flood Deck", "ksrflddeck", {ksrflood = true}, {x = 1, y = 5}, fld_def)
local crsdeck = SMODS.Deck:new("Curse Deck", "ksrcrsdeck", {ksrcurse = true, hand_size = -1}, {x = 2, y = 5}, crs_def)
jkrdeck:register()
flddeck:register()
crsdeck:register()

----------------------------------------------
------------MOD CODE END----------------------