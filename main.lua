--- STEAMODDED HEADER
--- MOD_NAME: Dede Joker
--- MOD_ID: DedeJoker
--- MOD_AUTHOR: [andrejunior]
--- MOD_DESCRIPTION: Adds the Dede Joker that enhances cards and boosts Flush hands
--- BADGE_COLOUR: 708b91
--- PREFIX: dede

SMODS.Joker {
    key = 'dede_joker',
    loc_txt = {
        name = 'Dede Joker',
        text = {
            'When you play a {C:attention}Flush{},',
            'all cards in hand gain',
            '{C:mult}+2{} Mult permanently',
            '{C:inactive}(Stacks){}',
            '{C:attention}Flush{} hands also gain',
            '{C:mult}+4{} Mult when scored'
        }
    },
    config = { extra = { mult_gain = 2, flush_mult = 4 } },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    atlas = 'dede_joker_atlas',
    pos = { x = 0, y = 0 },
    calculate = function(self, card, context)
        -- When playing a Flush, enhance all cards in hand
        if context.before and next(context.poker_hands['Flush']) then
            for i = 1, #G.hand.cards do
                local hand_card = G.hand.cards[i]
                if not hand_card.ability.mult then
                    hand_card.ability.mult = 0
                end
                hand_card.ability.mult = hand_card.ability.mult + card.ability.extra.mult_gain
                hand_card:juice_up(0.5, 0.5)
            end
            return {
                message = 'Enhanced!',
                colour = G.C.MULT
            }
        end

        -- When scoring a Flush, add extra mult
        if context.individual and context.cardarea == G.play and next(context.poker_hands['Flush']) then
            return {
                mult = card.ability.extra.flush_mult,
                message = 'Dedé Power!',
                colour = G.C.MULT
            }
        end
    end
}

-- Add Dede Joker to the player's collection at the start of each run
SMODS.registerHook("start_run", function()
    -- Create and add the Dede Joker to the player's jokers
    local dede_joker = SMODS.create_card("Joker", G.jokers, nil, nil, nil, nil, "dede_joker")
    G.jokers:emplace(dede_joker)
    return true
end)

-- Sprite registration
SMODS.Atlas {
    key = 'dede_joker_atlas',
    path = "assets/sprites/j_dede.png",
    px = 71,
    py = 95
}

-- Optional: Register 2x resolution for high-DPI displays
SMODS.Atlas {
    key = 'dede_joker_atlas_2x',
    path = "assets/sprites/j_dede_2x.png",
    px = 142,
    py = 190
}