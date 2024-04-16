--- STEAMODDED HEADER
--- MOD_NAME: Astronomer Deck
--- MOD_ID: AstronomerDeck
--- MOD_AUTHOR: [Vicendithas]
--- MOD_DESCRIPTION: A deck perfect for an aspiring astronomer!

----------------------------------------------
------------MOD CODE -------------------------

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

	if arg_56_0.effect.config.astronomer_d then
		G.E_MANAGER:add_event(Event({
			func = function()
				for iter_57_0 = #G.playing_cards, 1, -1 do
					G.playing_cards[iter_57_0]:set_seal('Blue', true, true)
				end
				
				local jokersList = {
					'j_constellation',
					'j_satellite',
					'j_astronomer'
				}
				
				for i = 1, #jokersList do
					local jokerType = jokersList[i]
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, jokerType, nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
				end

				return true
			end
		}))
	end
end

function SMODS.INIT.AstronomerDeck()
	local loc_def = {
		["name"]="Astronomer Deck",
		["text"]={
			[1]="A deck perfect for an",
			[2]="{C:attention}aspiring astronomer{}",
			[3]="Collect all the Planets!"
		},
	}

	local astronomerdeck = SMODS.Deck:new("Astronomer", "astronomer", {
		astronomer_d = true,
		vouchers = {"v_telescope", "v_observatory", "v_crystal_ball", "v_planet_merchant", "v_planet_tycoon"},
		}, {x = 3, y = 4}, loc_def)
	astronomerdeck:register()
end

----------------------------------------------
------------MOD CODE END----------------------
