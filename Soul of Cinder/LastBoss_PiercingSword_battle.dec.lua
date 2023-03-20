--Hopefully more readable

RegisterTableGoal(GOAL_LastBoss_PiercingSword_Battle, "LastBoss_PiercingSword")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_LastBoss_PiercingSword_Battle, true)

Goal.Initialize = function (_, _, _, _)
end

Goal.Activate = function (_, actor, goals)
    Init_Pseudo_Global(actor, goals)
    actor:SetStringIndexedNumber("Dist_SideStep", 7)
    actor:SetStringIndexedNumber("Dist_BackStep", 7)

    local probabilities = {}
    local acts = {}
    local f2_local0 = {} --??? don't worry about this
    Common_Clear_Param(probabilities, acts, f2_local0)
    local distance = actor:GetDist(TARGET_ENE_0)
    local hp_rate = actor:GetHpRate(TARGET_SELF)

    --Number(2) is basically a value stored in cinder, it goes up every time cinder attacks- by a different amount for each attack
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
        close_to_phase_change_modifier = 1
    else
        phase_change_chance = actor:GetRandam_Int(1, 10)
        close_to_phase_change_modifier = 0
    end

    local heal_weight_modifier
    if hp_rate >= 0.7 then
        heal_weight_modifier = 0
    elseif hp_rate >= 0.35 then
        heal_weight_modifier = 2
    else
        heal_weight_modifier = 1
    end

    --SpEffect 12118 = heal over time from lance phase
    --SpEffect 12116 = magic resistance buff? has anyone seen this?
    --SpEffect 12117 = power within damage buff
    --SpEffect 12120 = soul mass generator buff
    local is_not_buffed
    if actor:HasSpecialEffectId(TARGET_SELF, 12118) or actor:HasSpecialEffectId(TARGET_SELF, 12116) or actor:HasSpecialEffectId(TARGET_SELF, 12117) or actor:HasSpecialEffectId(TARGET_SELF, 12120) then
        is_not_buffed = 0
    else
        is_not_buffed = 1
    end

    --SpEffect 12115 = burst heal from lance phase
    --this effect is instant meaning it only lasts for a "moment" (1 frame?)
    --so I don't see how this condition can ever be true, maybe heal -> phase change is quick enough? still not sure
    local phase_sword_weight
    local phase_curved_weight
    local phase_staff_weight
    if actor:HasSpecialEffectId(TARGET_SELF, 12115) then
        phase_sword_weight = 1
        phase_curved_weight = 1
        phase_staff_weight = 3
    else
        phase_sword_weight = 1
        phase_curved_weight = 1.7
        phase_staff_weight = 1
    end
    --SpEffect 12126 = has changed to curved at some point
    local first_time_curved_modifier
    if actor:HasSpecialEffectId(TARGET_SELF, 12126) then
        first_time_curved_modifier = 1
    else
        first_time_curved_modifier = 20
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
        probabilities[32] = 100 * phase_curved_weight * first_time_curved_modifier
        probabilities[33] = 100 * phase_staff_weight * first_time_staff_modifier
    elseif distance >= 15 then
        probabilities[1] = 10
        probabilities[2] = 5
        probabilities[3] = 15
        probabilities[4] = 0
        probabilities[5] = 25
        probabilities[6] = 20
        probabilities[7] = 0
        probabilities[8] = 15
        probabilities[9] = 0
        probabilities[10] = 10 * is_not_buffed * close_to_phase_change_modifier * heal_weight_modifier
    elseif distance >= 10 then
        probabilities[1] = 10
        probabilities[2] = 5
        probabilities[3] = 10
        probabilities[4] = 0
        probabilities[5] = 25
        probabilities[6] = 20
        probabilities[7] = 0
        probabilities[8] = 20
        probabilities[9] = 0
        probabilities[10] = 10 * is_not_buffed * close_to_phase_change_modifier * heal_weight_modifier
    elseif distance >= 4.5 then
        probabilities[1] = 15
        probabilities[2] = 10
        probabilities[3] = 10
        probabilities[4] = 0
        probabilities[5] = 20
        probabilities[6] = 15
        probabilities[7] = 5 * close_to_phase_change_modifier / 3
        probabilities[8] = 15
        probabilities[9] = 0
        probabilities[10] = 10 * is_not_buffed * close_to_phase_change_modifier * heal_weight_modifier
    elseif distance >= 2 then
        probabilities[1] = 20
        probabilities[2] = 20
        probabilities[3] = 10
        probabilities[4] = 0
        probabilities[5] = 0
        probabilities[6] = 10
        probabilities[7] = 15 * close_to_phase_change_modifier / 3
        probabilities[8] = 10
        probabilities[9] = 5
        probabilities[10] = 10 * is_not_buffed * close_to_phase_change_modifier * heal_weight_modifier
    else
        probabilities[1] = 20
        probabilities[2] = 10
        probabilities[3] = 0
        probabilities[4] = 20
        probabilities[5] = 0
        probabilities[6] = 5
        probabilities[7] = 10 * close_to_phase_change_modifier / 3
        probabilities[8] = 5
        probabilities[9] = 20
        probabilities[10] = 10 * is_not_buffed * close_to_phase_change_modifier * heal_weight_modifier
    end
    probabilities[10] = SetCoolTime(actor, goals, 3008, 30, probabilities[10], 0)
    acts[1] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act01)
    acts[2] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act02)
    acts[3] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act03)
    acts[4] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act04)
    acts[5] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act05)
    acts[6] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act06)
    acts[7] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act07)
    acts[8] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act08)
    acts[9] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act09)
    acts[10] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act10)
    acts[30] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act30)
    acts[31] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act31)
    acts[32] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act32)
    acts[33] = REGIST_FUNC(actor, goals, LastBoss_PiercingSword_Act33)
    Common_Battle_Activate(actor, goals, probabilities, acts, REGIST_FUNC(actor, goals, LastBoss528000_ActAfter_AdjustSpace), f2_local0)
end

--GetMapHitRadius gets cinder's hitbox radius, which is 0.7.

--Start with poke and combo
function LastBoss_PiercingSword_Act01(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    if combo_length_random <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3000, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif combo_length_random <= 60 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        elseif random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
        end
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 45 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3020, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        elseif random <= 65 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3020, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with upward thrust and combo
function LastBoss_PiercingSword_Act02(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF)
    local can_run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 70 then
        actor:SetNumber(2, actor:GetNumber(2) + 6)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3001, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 70 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with running poke and combo
function LastBoss_PiercingSword_Act03(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 10 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 10 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    if combo_length_random <= 30 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3002, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif combo_length_random <= 70 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3002, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3013, TARGET_ENE_0, success_distance)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 70 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3002, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3002, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with quick left to right swipe and combo
function LastBoss_PiercingSword_Act04(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 70 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3005, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3005, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with running joust and combo
function LastBoss_PiercingSword_Act05(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 12 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 12 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 60 then
        actor:SetNumber(2, actor:GetNumber(2) + 6)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3010, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 70 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3010, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3010, TARGET_ENE_0, 10 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Lunging thrust and combo
function LastBoss_PiercingSword_Act06(actor, goals, _)
    local stop_distance = 12 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 12 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    if actor:GetDist(TARGET_ENE_0) <= 3 and InsideDir(actor, goals, 0, 90) then
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
    else
    end
    if combo_length_random <= 70 then
        actor:SetNumber(2, actor:GetNumber(2) + 6)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3011, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Grab
function LastBoss_PiercingSword_Act07(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 10)
    goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3013, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Double spin
function LastBoss_PiercingSword_Act08(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 10 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 10 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 10)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3023, TARGET_ENE_0, SuccessDist, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Wrath of the Gods
function LastBoss_PiercingSword_Act09(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 60 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3007, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3007, TARGET_ENE_0, 10 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Heal
function LastBoss_PiercingSword_Act10(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local is_not_silenced
    --SpEffect 103581000 = Vow of Silence
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        is_not_silenced = 0
    else
        is_not_silenced = 1
    end
    if distance <= 5 and is_not_silenced >= 1 then
        actor:SetNumber(2, actor:GetNumber(2) + 40)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3007, TARGET_ENE_0, 1000, turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3008, TARGET_ENE_0, success_distance)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 40)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3008, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to sword
function LastBoss_PiercingSword_Act30(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20000, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to lance
function LastBoss_PiercingSword_Act31(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20001, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to curved
function LastBoss_PiercingSword_Act32(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20002, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to staff
function LastBoss_PiercingSword_Act33(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, 0)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 20004, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--GOAL_LastBoss_AfterAttackAct is defined in the straight sword AI
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
    if actor:IsInterupt(INTERUPT_Shoot) then --Bullet (often ranged attack) "input read"
        if distance >= 20 and random <= 50 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 12 and random <= 30 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 5 and random <= 30 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 3023, TARGET_ENE_0, 20, 0, 0)
            return true
        end
    end
    return false
end
