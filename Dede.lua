--- STEAMODDED HEADER
--- MOD_NAME: Dede Joker
--- MOD_ID: DedeJoker
--- MOD_AUTHOR: [andrejunior]
--- MOD_DESCRIPTION: Adds the Dede Joker that enhances cards and boosts Flush hands
--- BADGE_COLOUR: 708b91
--- PREFIX: dede

-- Custom deck that starts with Dede Joker for immediate access
SMODS.Back {
    key = 'dede_deck',
    loc_txt = {
        name = 'Dédéck',
        text = {
            'Start with a {C:attention}Dédé Joker{}',
            'for immediate {C:attention}Flush{} synergy'
        }
    },
    config = {
        jokers = {'j_dede_joker'}  -- Fixed: Added 'j_' prefix
    },
    atlas = 'dede_joker_atlas',
    pos = { x = 0, y = 0 }
}

-- Sprite registration
SMODS.Atlas {
    key = 'dede_joker_atlas',
    path = "j_dede.png",
    px = 71,
    py = 95
}


SMODS.Joker {
    key = 'dede_joker',
    loc_txt = {
        name = 'Dédé Joker',
        text = {
            'When you play a {C:attention}Flush{},',
            'all cards in hand gain {C:mult}+3{} Mult',
            'and {C:chips}+15{} Chips permanently',
            '{C:attention}Flush{} hands gain {C:mult}+8{} Mult',
            'and level up. Earn {C:money}$3{}',
            '{C:green}#1# in #2#{} chance for {C:attention}Straight Flush{}',
            '{C:inactive}(Currently: {C:mult}+#3#{} Mult, {C:chips}+#4#{} Chips){}'
        }
    },
    config = { 
        extra = { 
            mult_gain = 3, 
            chip_gain = 15,
            flush_mult = 8, 
            money = 3,
            straight_flush_odds = 4,
            total_mult = 0,
            total_chips = 0,
            flushes_played = 0
        } 
    },
    rarity = 4,  -- Common rarity for frequent shop appearances
    cost = 8,    -- Balanced cost for accessibility
    discovered = true,
    unlocked = true,  -- Always unlocked
    blueprint_compat = true,
    perishable_compat = false,  -- Too powerful to be perishable
    eternal_compat = true,      -- Can be eternal
    atlas = 'dede_joker_atlas',
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                G.GAME.probabilities.normal or 1,
                center.ability.extra.straight_flush_odds,
                center.ability.extra.total_mult,
                center.ability.extra.total_chips
            }
        }
    end,
    calculate = function(self, card, context)
        -- Before scoring a Flush
        if context.before and next(context.poker_hands['Flush']) then
            -- Enhance all cards in hand
            for i = 1, #G.hand.cards do
                local hand_card = G.hand.cards[i]
                if not hand_card.ability.mult then
                    hand_card.ability.mult = 0
                end
                if not hand_card.ability.h_mult then
                    hand_card.ability.h_mult = 0
                end
                hand_card.ability.mult = hand_card.ability.mult + card.ability.extra.mult_gain
                hand_card.ability.h_mult = hand_card.ability.h_mult + card.ability.extra.chip_gain
                hand_card:juice_up(0.8, 0.8)
            end
            
            -- Update tracking variables
            card.ability.extra.total_mult = card.ability.extra.total_mult + card.ability.extra.mult_gain * #G.hand.cards
            card.ability.extra.total_chips = card.ability.extra.total_chips + card.ability.extra.chip_gain * #G.hand.cards
            card.ability.extra.flushes_played = card.ability.extra.flushes_played + 1
            
            -- Level up Flush hand
            if G.GAME.hands['Flush'] then
                level_up_hand(card, 'Flush', false, 1)
            end
            
            -- Earn money
            ease_dollars(card.ability.extra.money)
            
            -- Chance to convert to Straight Flush
            if pseudorandom('dede_straight_flush') < G.GAME.probabilities.normal / card.ability.extra.straight_flush_odds then
                G.GAME.current_round.hands_played = G.GAME.current_round.hands_played - 1
                G.GAME.current_round.discards_used = G.GAME.current_round.discards_used - 1
                return {
                    message = 'Straight Flush!',
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
            
            return {
                message = 'André Evolved!',
                colour = G.C.MULT
            }
        end

        -- Individual card scoring for Flush
        if context.individual and context.cardarea == G.play and next(context.poker_hands['Flush']) then
            local bonus_mult = card.ability.extra.flush_mult + math.floor(card.ability.extra.flushes_played / 3)
            return {
                mult = bonus_mult,
                chips = card.ability.extra.chip_gain * 2,
                message = 'André Power!',
                colour = G.C.MULT
            }
        end
        
        -- Bonus for other hands containing enhanced cards
        if context.joker_main and context.cardarea == G.play then
            local enhanced_cards = 0
            for i = 1, #context.scoring_hand do
                local scoring_card = context.scoring_hand[i]
                if scoring_card.ability.mult and scoring_card.ability.mult > 0 then
                    enhanced_cards = enhanced_cards + 1
                end
            end
            
            if enhanced_cards > 0 then
                return {
                    mult = enhanced_cards * 2,
                    message = 'Enhanced!',
                    colour = G.C.MULT
                }
            end
        end
    end
}

-- Increase Dede Joker shop appearance rate
local original_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    -- Increase chance for Dede Joker in shop
    if _type == 'Joker' and area and area == G.shop_jokers and not forced_key then
        if pseudorandom('dede_shop_boost') < 0.3 then  -- 30% chance to boost Dede Joker
            _rarity = 4  -- Force common rarity for higher spawn chance
        end
    end
    return original_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
end