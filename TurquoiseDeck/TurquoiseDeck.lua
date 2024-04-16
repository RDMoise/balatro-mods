--- STEAMODDED HEADER
--- MOD_NAME: Turquoise Deck
--- MOD_ID: TurquoiseDeck
--- MOD_AUTHOR: [Nrio]
--- MOD_DESCRIPTION: Probably the most boring Deck

----------------------------------------------
------------MOD CODE -------------------------

local tur_def = {
		["name"]="Turquoise Deck",
		["text"]={
			[1]="{C:attention}+1{} hand size, {C:red}-1{} discard",
			[2]="At the end of the round, change",
			[3]="suit and rank of the cards in hand",
		},
	}
	
function SMODS.INIT.PactDeck()

    local turquoisedeck_mod = SMODS.findModByID("TurquoiseDeck")
    local sprite_card = SMODS.Sprite:new("centers", turquoisedeck_mod.path, "Enhancers.png", 71, 95, "asset_atli")
    
    sprite_card:register()
end
	
-- Using the "AbsoluteDeck" mod as an example

local turDeck = SMODS.Deck:new("Turquoise Deck", "turquoise_decks", {turquoise = true, hand_size = 1, discards = -1}, {x = 0, y = 5}, tur_def)
turDeck:register()

local eval_card_ref = eval_card
function eval_card(card, context)
    context = context or {}
    local ret = {}
    if context.cardarea == G.hand and context.end_of_round and not (card.ability.set == 'Joker' or card.ability.set == 'Edition' or card.ability.consumeable or card.ability.set == 'Voucher' or card.ability.set == 'Booster') and G.GAME.starting_params.turquoise then
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.8,
			func = function()
			    local suit_prefix = pseudorandom_element({'S','H','D','C'})
        		    local rank_suffix = pseudorandom_element({'2','3','4','5','6','7','8','9','T','J','Q','K','A'})
        	            card:set_base(G.P_CARDS[suit_prefix..'_'..rank_suffix])
			    return true
			end
		}))
    end
	
    return eval_card_ref(card, context)
end

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(self)
	Backapply_to_runRef(self)

	if self.effect.config.turquoise then
		G.GAME.starting_params.turquoise = self.effect.config.turquoise
	end
end

----------------------------------------------
------------MOD CODE END----------------------