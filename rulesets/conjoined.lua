-- Conjoined tournament ruleset: Standard Ranked with more time on the clock so
-- teammates can talk decisions through.
--
-- pressure_timer already pauses the clock during animations, so the
-- no_animation_timer layer isn't needed on top of it.
MP.Ruleset({
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
	pvp_timer_base_seconds = 90,
	pvp_timer_hand_played_increment_seconds = 15,
}):inject()
