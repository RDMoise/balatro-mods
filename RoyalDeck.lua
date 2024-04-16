--- STEAMODDED HEADER
--- MOD_NAME: Royal Deck
--- MOD_ID: RoyalDeck
--- MOD_AUTHOR: [UnknownEternity]
--- MOD_DESCRIPTION: Adds 1 deck (Royal Deck): It contains only enhanced Aces, face cards, and 10s.

----------------------------------------
--------------- MOD CODE ---------------
----------------------------------------
function add_card_to_deck(arg_card)
    arg_card:add_to_deck()
    table.insert(G.playing_cards, arg_card)
    G.deck.config.card_limit = G.deck.config.card_limit + 1
    G.deck:emplace(arg_card)
end

function add_joker_to_game(arg_key, arg_loc, arg_joker)
    arg_joker.key = arg_key
    arg_joker.order = #G.P_CENTER_POOLS["Joker"] + 1

    G.P_CENTERS[arg_key] = arg_joker
    table.insert(G.P_CENTER_POOLS["Joker"], arg_joker)
    table.insert(G.P_JOKER_RARITY_POOLS[arg_joker.rarity], arg_joker)

    G.localization.descriptions.Joker[arg_key] = arg_loc
end

function SMODS.INIT.RoyalDeck()
    local jokers = {}

    local texts = {}

    for key,val in pairs(jokers) do
        add_joker_to_game(key, texts[key], val)
    end
end

local card_calculate_joker_ref = Card.calculate_joker
function Card.calculate_joker(self, context)
    local calculate_joker_ref = card_calculate_joker_ref(self, context)

    return calculate_joker_ref
end

local back_apply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(arg_royal)
    back_apply_to_run_ref(arg_royal)

    if arg_royal.effect.config.royalty then
        G.E_MANAGER:add_event(Event({
            func = function()
                -- code for cards
                local cards_by_suit = {
                    ["S"] = {},
                    ["H"] = {},
                    ["C"] = {},
                    ["D"] = {}
                }

                for idx = #G.playing_cards, 1, -1 do
                    sendDebugMessage(G.playing_cards[idx].base.suit .. G.playing_cards[idx].base.id)

                    local suit = string.sub(G.playing_cards[idx].base.suit, 1, 1)
                    local rank = tostring(G.playing_cards[idx].base.id)
                    if     rank == "1"  then rank = "T"
                    elseif rank == "10" then rank = "T"
                    elseif rank == "11" then rank = "J"
                    elseif rank == "12" then rank = "Q"
                    elseif rank == "13" then rank = "K"
                    elseif rank == "14" then rank = "A"
                    end
                  --G.playing_cards[idx]:set_base(G.P_CARDS[suit .. "_" .. rank])

                    if G.playing_cards[idx].base.id < 10 then
                        G.playing_cards[idx]:start_dissolve(nil, true)
                    else
                        table.insert(cards_by_suit[suit], G.playing_cards[idx])

                        if     rank == "A" then G.playing_cards[idx]:set_ability(G.P_CENTERS.m_mult)
                        elseif rank == "K" then G.playing_cards[idx]:set_ability(G.P_CENTERS.m_gold)
                        elseif rank == "Q" then G.playing_cards[idx]:set_ability(G.P_CENTERS.m_lucky)
                        elseif rank == "J" then G.playing_cards[idx]:set_ability(G.P_CENTERS.m_steel)
                        elseif rank == "T" then G.playing_cards[idx]:set_ability(G.P_CENTERS.m_bonus)
                        end
                    end
                end

                for idx = #cards_by_suit["S"], 1, -1 do
                end
                for idx = #cards_by_suit["H"], 1, -1 do
                end
                for idx = #cards_by_suit["C"], 1, -1 do
                end
                for idx = #cards_by_suit["D"], 1, -1 do
                end

                G.starting_deck_size = #G.playing_cards

                -- code for jokers
                local joker_list = {}
                for idx = 1, #joker_list, 1 do
                    local card = create_card('Joker', G.jokers, false, nil, nil, nil, joker_list[idx], nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                end
                return true
            end
        }))
    end
end

local loc_def_royal = {
    ["name"]="Royal Deck",
    ["text"]={
        [1]="This deck contains only",
        [2]="Aces, face cards, and 10s.",
        [3]="These cards are enhanced",
        [4]="depending on their rank.",
        [5]="Start with {C:attention,T:v_seed_money}Seed Money{}.",
        [6]="-2 {C:blue}Hands{} and -1 {C:red}Discard{}"
    }
}

local d_royal = SMODS.Deck:new("Royal_Deck", "royal", {royalty = true, hands = -2, discards = -1, voucher = 'v_seed_money'}, {x = 6, y = 0}, loc_def_royal)
d_royal:register()
----------------------------------------
------------- MOD CODE END -------------
----------------------------------------