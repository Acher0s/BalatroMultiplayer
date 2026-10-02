-- Conjoined tournament ruleset: Standard Ranked with more time on the clock so
-- teammates can talk decisions through.
--
-- pressure_timer already pauses the clock during animations, so the
-- no_animation_timer layer isn't needed on top of it.
local conjoined = MP.Ruleset({
	key = "conjoined",
	layers = { "standard", "ranked", "pressure_timer", "pvp_timer" },
	forced_gamemode = "gamemode_mp_attrition",
	force_lobby_options = function(self)
		MP.Layers.ranked.force_lobby_options(self)
		MP.LOBBY.config.timer_base_seconds = 300
		-- No time bonus when the opponent skips a blind
		MP.LOBBY.config.timer_increment_seconds = 0
		return true
	end,
	-- Ruleset values beat the layers': keep the 300s base as-is (pressure_timer
	-- doubles it) and don't drain a timered player's clock faster.
	timer_base_multiplier = 1,
	timer_speedup_multiplier = 1,
	-- The clock before the first PvP spans ante 1 and most of ante 2
	first_pvp_timer_bonus_seconds = 100,
	banned_jokers = { "j_mp_skip_off" },
	-- Listed so it shows in the Reworks tab (see the rework below)
	reworked_jokers = { "j_mp_conjoined_joker" },
	pvp_timer_base_seconds = 90,
	pvp_timer_hand_played_increment_seconds = 15,
})

-- The standard layer bans Conjoined Joker; this ruleset brings it back, reworked.
-- Layer ban lists can only be added to, so drop it from the merged list here.
for i = #conjoined.banned_jokers, 1, -1 do
	if conjoined.banned_jokers[i] == "j_mp_conjoined_joker" then table.remove(conjoined.banned_jokers, i) end
end

conjoined:inject()

-- Conjoined Joker rework: $5, X2 Mult while in a PvP Blind. Its own calculate()
-- already applies extra.x_mult only in PvP Blinds (and never for the phantom copy),
-- and the JokerDisplay/Preview integrations read the same value, so the rework only
-- fixes x_mult at 2 and turns off update(), which would otherwise keep recomputing
-- it from the Nemesis' remaining hands. Sending/removing the phantom on the
-- Nemesis' side (add_to_deck/remove_from_deck) is untouched.
MP.ReworkCenter("j_mp_conjoined_joker", {
	layers = "conjoined",
	loc_key = "j_mp_conjoined_joker_conjoined",
	cost = 5,
	config = { extra = { x_mult = 2 } },
	update = function(self, card, dt) end,
	loc_vars = function(self, info_queue, card)
		MP.UTILS.add_nemesis_info(info_queue)
		return { vars = { card.ability.extra.x_mult } }
	end,
})
