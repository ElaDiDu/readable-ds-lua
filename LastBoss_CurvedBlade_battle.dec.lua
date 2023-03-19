--Hopefully more readable

RegisterTableGoal(GOAL_LastBoss_CurvedBlade_Battle, "LastBoss_CurvedBlade")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_LastBoss_CurvedBlade_Battle, true)

--This is executed when the AI is created
Goal.Initialize = function (_, _, _, _)
end

--This is executed when the AI has no goals (usually after after finishing an attack, or after making some distance)
--Goals can be "do attack x", "turn left", "back off until 2 meters from target" etc.
Goal.Activate = function (_, actor, goals)
    Init_Pseudo_Global(actor, goals)
    actor:SetStringIndexedNumber("Dist_SideStep", 7) --idk lol, the distance he covers with a sidestep? Don't know when the AI uses this though
    actor:SetStringIndexedNumber("Dist_BackStep", 7) --same

    --an array that behaves as a map with weights for each act (e.g "do a 2 hit combo" = 50, "phase transition" = 20, etc.)
    local probabilities = {}

    local acts = {} --an array with all the acts
    local f2_local0 = {} --??? don't worry about this
    Common_Clear_Param(probabilities, acts, f2_local0)
    --TARGET_ENE_0 is just his current target, usually you!
    local distance_from_target = actor:GetDist(TARGET_ENE_0)
    actor:GetHpRate(TARGET_SELF) --Gets cinder's hp % (not assigned to anything? ignore this line I guess)

    --Number(2) is basically a value stored in cinder, it goes up every time cinder attacks, by a different amount for each attack
    --you can mentally replace Number(2) with "how much has cinder attacked/how much will he want to phase change"

    local phase_change_chance --if this value is at least 100, cinder will phase change
    local close_to_phase_change_modifier --the closer he is to phase changing, the higher this is
    if actor:GetNumber(2) >= 150 then
        phase_change_chance = actor:GetRandam_Int(100, 120)
        close_to_phase_change_modifier = 20
    elseif actor:GetNumber(2) >= 100 then
        phase_change_chance = actor:GetRandam_Int(90, 120)
        close_to_phase_change_modifier = 10
    elseif actor:GetNumber(2) >= 75 then
        phase_change_chance = actor:GetRandam_Int(60, 120)
        close_to_phase_change_modifier = 5
    elseif actor:GetNumber(2) >= 50 then
        phase_change_chance = actor:GetRandam_Int(10, 110)
        close_to_phase_change_modifier = 2
    else
        phase_change_chance = actor:GetRandam_Int(1, 10)
        close_to_phase_change_modifier = 1
    end

    --SpEffect 12118 = heal over time from lance phase
    --SpEffect 12116 = magic resistance buff? has anyone seen this?
    --SpEffect 12117 = power within damage buff
    --SpEffect 12120 = soul mass generator buff
    --this is used so he'll only try to buff when he doesn't already have a buff active
    local is_not_buffed
    if actor:HasSpecialEffectId(TARGET_SELF, 12118) or actor:HasSpecialEffectId(TARGET_SELF, 12116) or actor:HasSpecialEffectId(TARGET_SELF, 12117) or actor:HasSpecialEffectId(TARGET_SELF, 12120) then
        is_not_buffed = 0
    else
        is_not_buffed = 1
    end
    local phase_sword_weight
    local phase_lance_weight
    local phase_staff_weight
    if actor:HasSpecialEffectId(TARGET_SELF, 12117) then --if has power within then:
        phase_sword_weight = 2.5
        phase_lance_weight = 1
        phase_staff_weight = 0.5
    else
        phase_sword_weight = 1.7
        phase_lance_weight = 1
        phase_staff_weight = 1
    end
    --SpEffect 12125 = has changed to lance at some point
    local first_time_lance_modifier
    if actor:HasSpecialEffectId(TARGET_SELF, 12125) then
        first_time_lance_modifier = 1
    else
        first_time_lance_modifier = 20
    end
    --SpEffect 12127 = has changed to staff at some point
    local first_time_staff_modifier
    if actor:HasSpecialEffectId(TARGET_SELF, 12127) then
        first_time_staff_modifier = 1
    else
        first_time_staff_modifier = 20
    end
    if phase_change_chance >= 100 then
        probabilities[30] = 100 * phase_sword_weight
        probabilities[31] = 100 * phase_lance_weight * first_time_lance_modifier
        probabilities[33] = 100 * phase_staff_weight * first_time_staff_modifier
    elseif distance_from_target >= 15 then
        probabilities[1] = 5
        probabilities[2] = 10
        probabilities[3] = 10
        probabilities[4] = 0
        probabilities[5] = 0
        probabilities[7] = 0
        probabilities[6] = 20
        probabilities[8] = 0
        probabilities[11] = 20 * close_to_phase_change_modifier / 3
        probabilities[9] = 0
        probabilities[10] = 20
        probabilities[12] = 0
        probabilities[13] = 15 * is_not_buffed * close_to_phase_change_modifier
    elseif distance_from_target >= 8 then
        probabilities[1] = 10
        probabilities[2] = 10
        probabilities[3] = 15
        probabilities[4] = 0
        probabilities[5] = 0
        probabilities[7] = 0
        probabilities[6] = 15
        probabilities[8] = 0
        probabilities[11] = 15 * close_to_phase_change_modifier / 3
        probabilities[9] = 0
        probabilities[10] = 20
        probabilities[12] = 0
        probabilities[13] = 15 * is_not_buffed * close_to_phase_change_modifier
    elseif distance_from_target >= 5 then
        probabilities[1] = 10
        probabilities[2] = 10
        probabilities[3] = 5
        probabilities[4] = 0
        probabilities[5] = 0
        probabilities[7] = 0
        probabilities[6] = 20
        probabilities[8] = 0
        probabilities[11] = 15 * close_to_phase_change_modifier / 3
        probabilities[9] = 0
        probabilities[10] = 10
        probabilities[12] = 20
        probabilities[13] = 10 * is_not_buffed * close_to_phase_change_modifier
    elseif distance_from_target >= 2 then
        probabilities[1] = 10
        probabilities[2] = 15
        probabilities[3] = 10
        probabilities[4] = 8
        probabilities[5] = 7
        probabilities[7] = 0
        probabilities[6] = 10
        probabilities[8] = 5
        probabilities[11] = 10
        probabilities[9] = 0
        probabilities[10] = 0
        probabilities[12] = 15
        probabilities[13] = 10 * is_not_buffed * close_to_phase_change_modifier
    else
        probabilities[1] = 10
        probabilities[2] = 15
        probabilities[3] = 5
        probabilities[4] = 7
        probabilities[5] = 8
        probabilities[7] = 15
        probabilities[6] = 0
        probabilities[8] = 10
        probabilities[11] = 0
        probabilities[9] = 20
        probabilities[10] = 0
        probabilities[12] = 0
        probabilities[13] = 10 * is_not_buffed * close_to_phase_change_modifier
    end

    --SetCoolTime here is used to make a cool down for certain acts/animations
    --if not enough time has passed since the last time an animation was used it returns the last argument (usually 0 or 1, both are meant to convey the same thing, i.e set chance to 0)
    --SetCoolTime(actor, goals, animation ID, cooldown (seconds), weight to change?, in cooldown weight)
    probabilities[12] = SetCoolTime(actor, goals, 3023, 30, probabilities[12], 0)
    probabilities[13] = SetCoolTime(actor, goals, 3025, 30, probabilities[13], 0)
    acts[1] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act01)
    acts[2] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act02)
    acts[3] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act03)
    acts[4] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act04)
    acts[5] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act05)
    acts[6] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act06)
    acts[7] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act07)
    acts[8] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act08)
    acts[9] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act09)
    acts[10] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act10)
    acts[11] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act11)
    acts[12] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act12)
    acts[13] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act13)
    acts[30] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act30)
    acts[31] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act31)
    acts[32] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act32)
    acts[33] = REGIST_FUNC(actor, goals, LastBoss_CurvedBlade_Act33)
    Common_Battle_Activate(actor, goals, probabilities, acts, REGIST_FUNC(actor, goals, LastBoss528000_ActAfter_AdjustSpace), f2_local0)
end

function LastBoss_CurvedBlade_Act01(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF)
    local run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF)
    local force_run_distance = 999
    local f3_local3 = 100
    local f3_local4 = 0
    local f3_local5 = 3
    local f3_local6 = 5
    Approach_Act_Flex(actor, goals, stop_distance, run_distance, force_run_distance, f3_local3, f3_local4, f3_local5, f3_local6)
    local f3_local7 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random0 = actor:GetRandam_Int(1, 100)
    local random1 = actor:GetRandam_Int(1, 100)
    if random0 <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3000, TARGET_ENE_0, f3_local7, turn_time_before, front_decision_angle)
    elseif random0 <= 50 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random1 <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 2 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, f3_local7)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3012, TARGET_ENE_0, f3_local7)
        end
    elseif random0 <= 80 then
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random1 <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3002, TARGET_ENE_0, 2 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, f3_local7)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3002, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, f3_local7)
        end
    else
        actor:SetNumber(2, actor:GetNumber(2) + 16)
        if random1 <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3002, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3012, TARGET_ENE_0, f3_local7)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3002, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 2 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, f3_local7)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act02(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f4_local0 = 4 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local f4_local1 = 4 - actor:GetMapHitRadius(TARGET_SELF)
    local f4_local2 = 999
    local f4_local3 = 100
    local f4_local4 = 0
    local f4_local5 = 3
    local f4_local6 = 5
    Approach_Act_Flex(actor, goals, f4_local0, f4_local1, f4_local2, f4_local3, f4_local4, f4_local5, f4_local6)
    local f4_local7 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random0 = actor:GetRandam_Int(1, 100)
    local random1 = actor:GetRandam_Int(1, 100)
    if random0 <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3001, TARGET_ENE_0, f4_local7, turn_time_before, front_decision_angle)
    elseif random0 <= 60 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random1 <= 20 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3005, TARGET_ENE_0, f4_local7)
        elseif random1 <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3006, TARGET_ENE_0, f4_local7)
        elseif random1 <= 75 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, f4_local7)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, f4_local7)
        end
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random1 <= 35 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3002, TARGET_ENE_0, f4_local7)
        elseif random1 <= 60 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, f4_local7)
        elseif random1 <= 80 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3005, TARGET_ENE_0, f4_local7)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3006, TARGET_ENE_0, f4_local7)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act03(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f5_local0 = 4.5 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local f5_local1 = 4.5 - actor:GetMapHitRadius(TARGET_SELF)
    local f5_local2 = 999
    local f5_local3 = 100
    local f5_local4 = 0
    local f5_local5 = 3
    local f5_local6 = 5
    Approach_Act_Flex(actor, goals, f5_local0, f5_local1, f5_local2, f5_local3, f5_local4, f5_local5, f5_local6)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random0 = actor:GetRandam_Int(1, 100)
    local random1 = actor:GetRandam_Int(1, 100)
    if random0 <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3002, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif random0 <= 30 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3002, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, success_distance)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random1 <= 25 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3002, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, success_distance)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 6001, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3002, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act04(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3005, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3005, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 6001, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3005, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act05(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3006, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 70 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3006, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 6001, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3006, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act06(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f8_local0 = 4.5 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local f8_local1 = 4.5 - actor:GetMapHitRadius(TARGET_SELF)
    local f8_local2 = 999
    local f8_local3 = 100
    local f8_local4 = 0
    local f8_local5 = 3
    local f8_local6 = 5
    Approach_Act_Flex(actor, goals, f8_local0, f8_local1, f8_local2, f8_local3, f8_local4, f8_local5, f8_local6)
    local f8_local7 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    if random <= 25 then
        actor:SetNumber(2, actor:GetNumber(2) + 6)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3010, TARGET_ENE_0, f8_local7, turn_time_before, front_decision_angle)
    elseif random <= 70 then
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3010, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, f8_local7)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 18)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3010, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, f8_local7)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act07(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 70 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3011, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3011, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3014, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act08(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f10_local0 = 4 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local f10_local1 = 4 - actor:GetMapHitRadius(TARGET_SELF) - 2
    local f10_local2 = 999
    local f10_local3 = 100
    local f10_local4 = 0
    local f10_local5 = 3
    local f10_local6 = 5
    Approach_Act_Flex(actor, goals, f10_local0, f10_local1, f10_local2, f10_local3, f10_local4, f10_local5, f10_local6)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 20 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3012, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 80 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 6001, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act09(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f11_local0 = 5 - actor:GetMapHitRadius(TARGET_SELF) - 2.5
    local f11_local1 = 5 - actor:GetMapHitRadius(TARGET_SELF)
    local f11_local2 = 999
    local f11_local3 = 100
    local f11_local4 = 0
    local f11_local5 = 3
    local f11_local6 = 5
    Approach_Act_Flex(actor, goals, f11_local0, f11_local1, f11_local2, f11_local3, f11_local4, f11_local5, f11_local6)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 4)
    goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3020, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act10(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f12_local0 = 12 - actor:GetMapHitRadius(TARGET_SELF)
    local f12_local1 = 12 - actor:GetMapHitRadius(TARGET_SELF) + 3
    local f12_local2 = 999
    local f12_local3 = 100
    local f12_local4 = 0
    local f12_local5 = 3
    local f12_local6 = 5
    Approach_Act_Flex(actor, goals, f12_local0, f12_local1, f12_local2, f12_local3, f12_local4, f12_local5, f12_local6)
    local f12_local7 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    local f12_local8 = nil
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        f12_local8 = 0
    else
        f12_local8 = 1
    end
    if random <= 70 or f12_local8 == 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3021, TARGET_ENE_0, f12_local7, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3021, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3021, TARGET_ENE_0, f12_local7)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act11(actor, goals, _)
    local f13_local0 = 5.5 - actor:GetMapHitRadius(TARGET_SELF) + 2
    local f13_local1 = 5.5 - actor:GetMapHitRadius(TARGET_SELF)
    local f13_local2 = 999
    local f13_local3 = 100
    local f13_local4 = 0
    local f13_local5 = 1.5
    local f13_local6 = 5
    Approach_Act_Flex(actor, goals, f13_local0, f13_local1, f13_local2, f13_local3, f13_local4, f13_local5, f13_local6)
    local f13_local7 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    if actor:GetDist(TARGET_ENE_0) <= 5.5 - actor:GetMapHitRadius(TARGET_SELF) then
        actor:SetNumber(2, actor:GetNumber(2) + 10)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3014, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, f13_local7)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 10)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6000, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, f13_local7)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act12(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local f14_local0 = 8 - actor:GetMapHitRadius(TARGET_SELF)
    local f14_local1 = 8 - actor:GetMapHitRadius(TARGET_SELF) + 3
    local f14_local2 = 999
    local f14_local3 = 100
    local f14_local4 = 0
    local f14_local5 = 1.5
    local f14_local6 = 5
    Approach_Act_Flex(actor, goals, f14_local0, f14_local1, f14_local2, f14_local3, f14_local4, f14_local5, f14_local6)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 10)
    goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3023, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
end

function LastBoss_CurvedBlade_Act13(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    if distance <= 5 then
        actor:SetNumber(2, actor:GetNumber(2) + 40)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6001, TARGET_ENE_0, 100 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 6001, TARGET_ENE_0, 100 - actor:GetMapHitRadius(TARGET_SELF))
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3025, TARGET_ENE_0, success_distance)
    elseif distance <= 10 then
        actor:SetNumber(2, actor:GetNumber(2) + 40)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6001, TARGET_ENE_0, 100 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3025, TARGET_ENE_0, success_distance)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 40)
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3025, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    end
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
end

--Change to regular sword
function LastBoss_CurvedBlade_Act30(actor, goals, _)
    local f16_local0 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local f16_local1 = 0
    local f16_local2 = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20000, TARGET_ENE_0, f16_local0, f16_local1, f16_local2)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to lance
function LastBoss_CurvedBlade_Act31(actor, goals, _)
    local f17_local0 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local f17_local1 = 0
    local f17_local2 = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20001, TARGET_ENE_0, f17_local0, f17_local1, f17_local2)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to curved sword
function LastBoss_CurvedBlade_Act32(actor, goals, _)
    local f18_local0 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local f18_local1 = 0
    local f18_local2 = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20002, TARGET_ENE_0, f18_local0, f18_local1, f18_local2)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to staff
function LastBoss_CurvedBlade_Act33(actor, goals, _)
    local f19_local0 = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local f19_local1 = 0
    local f19_local2 = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20004, TARGET_ENE_0, f19_local0, f19_local1, f19_local2)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

function LastBoss528000_ActAfter_AdjustSpace(_, goals, _)
    goals:AddSubGoal(GOAL_LastBoss_AfterAttackAct, 10)
end

Goal.Update = function (arg0, arg1, arg2)
    return Update_Default_NoSubGoal(arg0, arg1, arg2)
end

Goal.Terminate = function (_, _, _)
end

Goal.Interrupt = function (_, actor, goals)
    local distance = actor:GetDist(TARGET_ENE_0)
    local random = actor:GetRandam_Int(1, 100)
    if actor:IsInterupt(INTERUPT_Shoot) then
        if distance >= 20 and random <= 100 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 12 and random <= 50 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 5 and random <= 30 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        end
    end
    if actor:IsInterupt(INTERUPT_ParryTiming) then
        if InsideRange(actor, goals, 0, 120, -99, 2) then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_StabCounterAttack, 1.25, 4000, TARGET_SELF, DIST_None, 0, 180, 0, 0)
            return true
        end
    elseif actor:IsInterupt(INTERUPT_SuccessParry) and InsideRange(actor, goals, 0, 120, -99, 3) then
        goals:ClearSubGoal()
        goals:AddSubGoal(GOAL_COMMON_ApproachTarget, 3, TARGET_ENE_0, 1, TARGET_SELF, false, -1)
        goals:AddSubGoal(GOAL_COMMON_Wait, actor:GetRandam_Float(0.3, 0.6), TARGET_ENE_0)
        actor:SetNumber(2, actor:GetNumber(2) + 20)
        goals:AddSubGoal(GOAL_COMMON_Attack, 10, 3110, TARGET_ENE_0, 3, 0)
        return true
    end
    return false
end
