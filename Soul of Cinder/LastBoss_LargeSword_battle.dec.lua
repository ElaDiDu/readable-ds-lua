--Hopefully more readable

RegisterTableGoal(GOAL_LastBoss_LargeSword_Battle, "LastBoss_LargeSword")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_LastBoss_LargeSword_Battle, true)

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
    actor:SetNumber(0, 0) --Used for phase 2
    actor:SetNumber(1, 0) --Used for phase 2
    local distance = actor:GetDist(TARGET_ENE_0)
    local random = actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)

    --Number(2) is basically a value stored in cinder, it goes up every time cinder attacks- by a different amount for each attack
    --you can mentally replace Number(2) with "how much has cinder attacked/how much will he want to phase change"

    local phase_change_chance
    if actor:GetNumber(2) >= 150 then
        phase_change_chance = actor:GetRandam_Int(100, 120)
    elseif actor:GetNumber(2) >= 100 then
        phase_change_chance = actor:GetRandam_Int(90, 120)
    elseif actor:GetNumber(2) >= 75 then
        phase_change_chance = actor:GetRandam_Int(60, 120)
    elseif actor:GetNumber(2) >= 50 then
        phase_change_chance = actor:GetRandam_Int(10, 110)
    else
        phase_change_chance = actor:GetRandam_Int(1, 10)
    end

    local phase_lance_weight
    local phase_curved_weight
    local phase_staff_weight
    if hp_rate <= 0.3 then
        phase_lance_weight = 4
        phase_curved_weight = 1
        phase_staff_weight = 1
    elseif hp_rate >= 0.7 then
        phase_lance_weight = 1
        phase_curved_weight = 1
        phase_staff_weight = 4
    else
        phase_lance_weight = 1.5
        phase_curved_weight = 1.5
        phase_staff_weight = 0.5
    end
    --SpEffect 12125 = has changed to lance at some point
    local first_time_lance_modifier
    if actor:HasSpecialEffectId(TARGET_SELF, 12125) then
        first_time_lance_modifier = 1
    else
        first_time_lance_modifier = 20
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
    if phase_change_chance >= 100 and hp_rate <= 0.85 then
        probabilities[31] = 100 * phase_lance_weight * first_time_lance_modifier
        probabilities[32] = 100 * phase_curved_weight * first_time_curved_modifier
        probabilities[33] = 100 * phase_staff_weight * first_time_staff_modifier
    elseif distance >= 12 then
        probabilities[1] = 10
        probabilities[2] = 10
        probabilities[3] = 5
        probabilities[4] = 20
        probabilities[5] = 20
        probabilities[6] = 20
        probabilities[10] = 5
        probabilities[11] = 15
        probabilities[12] = 0
    elseif distance >= 8 then
        probabilities[1] = 5
        probabilities[2] = 5
        probabilities[3] = 10
        probabilities[4] = 20
        probabilities[5] = 10
        probabilities[6] = 20
        probabilities[10] = 10
        probabilities[11] = 20
        probabilities[12] = 0
    elseif distance >= 5 then
        probabilities[1] = 10
        probabilities[2] = 10
        probabilities[3] = 5
        probabilities[4] = 15
        probabilities[5] = 15
        probabilities[6] = 15
        probabilities[10] = 10
        probabilities[11] = 15
        probabilities[12] = 5
    elseif distance >= 2 then
        probabilities[1] = 15
        probabilities[2] = 10
        probabilities[3] = 15
        probabilities[4] = 5
        probabilities[5] = 10
        probabilities[6] = 5
        probabilities[10] = 15
        probabilities[11] = 10
        probabilities[12] = 15
    elseif random >= 70 and InsideDir(actor, goals, 135, 45) then
        probabilities[7] = 80
        probabilities[9] = 20
    elseif random >= 70 and InsideDir(actor, goals, -135, 45) then
        probabilities[8] = 80
        probabilities[9] = 20
    elseif random >= 60 and InsideDir(actor, goals, -180, 45) then
        probabilities[9] = 100
    else
        probabilities[1] = 20
        probabilities[2] = 20
        probabilities[3] = 15
        probabilities[4] = 0
        probabilities[5] = 10
        probabilities[6] = 5
        probabilities[10] = 15
        probabilities[11] = 0
        probabilities[12] = 15
    end
    probabilities[10] = SetCoolTime(actor, goals, 3015, 8, probabilities[10], 0)
    probabilities[11] = SetCoolTime(actor, goals, 3015, 8, probabilities[11], 0)
    probabilities[12] = SetCoolTime(actor, goals, 3015, 8, probabilities[12], 0)
    acts[1] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act01)
    acts[2] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act02)
    acts[3] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act03)
    acts[4] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act04)
    acts[5] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act05)
    acts[6] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act06)
    acts[7] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act07)
    acts[8] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act08)
    acts[9] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act09)
    acts[10] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act10)
    acts[11] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act11)
    acts[12] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act12)
    acts[30] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act30)
    acts[31] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act31)
    acts[32] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act32)
    acts[33] = REGIST_FUNC(actor, goals, LastBoss_LargeSword_Act33)
    Common_Battle_Activate(actor, goals, probabilities, acts, REGIST_FUNC(actor, goals, LastBoss528000_ActAfter_AdjustSpace), f2_local0)
end

--GetMapHitRadius gets cinder's hitbox radius, which is 0.7.

--Start with right to left swing and combo
function LastBoss_LargeSword_Act01(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 5 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 5 - actor:GetMapHitRadius(TARGET_SELF) + 1
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
        if random <= 20 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        elseif random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 8 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3021, TARGET_ENE_0, success_distance)
        elseif random <= 75 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3004, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat_SuccessAngle180, 10, 3015, TARGET_ENE_0, 100)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, success_distance)
        end
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 20 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3020, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3022, TARGET_ENE_0, success_distance)
        elseif random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3020, TARGET_ENE_0, 7 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
        elseif random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3020, TARGET_ENE_0, 7.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3024, TARGET_ENE_0, success_distance)
        elseif random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 8 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3021, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3022, TARGET_ENE_0, success_distance)
        elseif random <= 60 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 8 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3021, TARGET_ENE_0, 7 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 8 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3021, TARGET_ENE_0, 7.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3024, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with left to right swing and combo
function LastBoss_LargeSword_Act02(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 5 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 5 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    if combo_length_random <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3001, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif combo_length_random <= 60 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3001, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3022, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3001, TARGET_ENE_0, 7 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
        end
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3022, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        elseif random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3022, TARGET_ENE_0, 7 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 7.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3024, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3003, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with uppercut and combo
function LastBoss_LargeSword_Act03(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF)
    local can_run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 0 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3002, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 25 then
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3002, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, success_distance)
        elseif random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3002, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        elseif random <= 75 then
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3002, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3003, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3002, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3004, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with overhead slam and combo
function LastBoss_LargeSword_Act04(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    if actor:GetRandam_Int(1, 100) <= 30 then
        actor:SetNumber(2, actor:GetNumber(2) + 6)
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3003, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3003, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3003, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3003, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat_SuccessAngle180, 10, 3015, TARGET_ENE_0, 100)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Start with thrust and combo
function LastBoss_LargeSword_Act05(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    if combo_length_random <= 20 then
        actor:SetNumber(2, actor:GetNumber(2) + 4)
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3004, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif combo_length_random <= 60 then
        actor:SetNumber(2, actor:GetNumber(2) + 8)
        if random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3004, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3020, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3004, TARGET_ENE_0, 8 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3021, TARGET_ENE_0, success_distance)
        end
    else
        actor:SetNumber(2, actor:GetNumber(2) + 12)
        if random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3004, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3020, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3022, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3004, TARGET_ENE_0, 8 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3021, TARGET_ENE_0, 5.5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3022, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Running overhead slam
function LastBoss_LargeSword_Act06(actor, goals, _)
    local stop_distance = 12 - actor:GetMapHitRadius(TARGET_SELF) - 4
    local can_run_distance = 0
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 10)
    if actor:GetDist(TARGET_ENE_0) >= 3 then
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3005, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 6001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3005, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Turning right swing
function LastBoss_LargeSword_Act07(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 4)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3006, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Turning left swing
function LastBoss_LargeSword_Act08(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 4)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3007, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Turning behind swing
function LastBoss_LargeSword_Act09(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 4)
    goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3008, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Imbued uppercuts
function LastBoss_LargeSword_Act10(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    if combo_length_random <= 30 then
        actor:SetNumber(2, actor:GetNumber(2) + 7)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3015, TARGET_ENE_0, 100, turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3010, TARGET_ENE_0, success_distance)
    elseif combo_length_random <= 75 then
        actor:SetNumber(2, actor:GetNumber(2) + 14)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, 100)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, 100)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3013, TARGET_ENE_0, success_distance)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 21)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, 100)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, 100)
        goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3014, TARGET_ENE_0, 4 - actor:GetMapHitRadius(TARGET_SELF))
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3013, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Imbued thrust
function LastBoss_LargeSword_Act11(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 7 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 7 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 14)
    goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, 100)
    goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Imbued twirl swing
function LastBoss_LargeSword_Act12(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 4 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(2, actor:GetNumber(2) + 14)
    goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, 100)
    goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3012, TARGET_ENE_0, success_distance)
    GetWellSpace_Odds = 100
    return GetWellSpace_Odds
end

--Change to sword
function LastBoss_LargeSword_Act30(actor, goals, _)
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
function LastBoss_LargeSword_Act31(actor, goals, _)
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
function LastBoss_LargeSword_Act32(actor, goals, _)
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
function LastBoss_LargeSword_Act33(actor, goals, _)
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

function LastBoss528000_ActAfter_AdjustSpace(_, goals, _)
    goals:AddSubGoal(GOAL_LastBoss_AfterAttackAct, 10)
end

Goal.Update = function (arg0, arg1, arg2)
    return Update_Default_NoSubGoal(arg0, arg1, arg2)
end

Goal.Terminate = function (_, _, _)
end

Goal.Interrupt = function (_, _, _)
    return false
end

--This is what is used if the GetWellSpace_Odds check is passed
RegisterTableGoal(GOAL_LastBoss_AfterAttackAct, "LastBoss_AfterAttackAct")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_LastBoss_AfterAttackAct, true)

--You can see it's mostly just idling/walking around, IsGuard is always false as cinder can't guard/block
Goal.Activate = function (_, actor, goals)
    local distance = actor:GetDist(TARGET_ENE_0)
    actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    local sideway_move_life_far = actor:GetRandam_Float(2, 3)
    local sideway_move_direction = actor:GetRandam_Int(0, 1)
    local sideway_move_desired_angle = actor:GetRandam_Int(30, 45)
    local leave_target_life_far = actor:GetRandam_Float(2, 3)
    local leave_target_stop_distance_far = distance + actor:GetRandam_Float(6, 8)
    local sideway_move_life_close = actor:GetRandam_Float(1, 2)
    local leave_target_life_close = actor:GetRandam_Float(1.3, 1.7)
    local leave_target_stop_distance_close = distance + actor:GetRandam_Float(3, 5)
    if distance >= 10 then
        if random <= 80 then
            goals:AddSubGoal(GOAL_COMMON_SidewayMove, sideway_move_life_far, TARGET_ENE_0, sideway_move_direction, sideway_move_desired_angle, true, true, IsGuard)
        elseif random <= 100 then
            goals:AddSubGoal(GOAL_COMMON_LeaveTarget, leave_target_life_far, TARGET_ENE_0, leave_target_stop_distance_far, TARGET_ENE_0, true, IsGuard)
        else
            goals:AddSubGoal(GOAL_COMMON_ApproachTarget, 4, TARGET_ENE_0, 4, TARGET_SELF, true, -1)
        end
    elseif distance >= 6 then
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_SidewayMove, sideway_move_life_far, TARGET_ENE_0, sideway_move_direction, sideway_move_desired_angle, true, true, IsGuard)
        elseif random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_LeaveTarget, leave_target_life_far, TARGET_ENE_0, leave_target_stop_distance_far, TARGET_ENE_0, true, IsGuard)
        end
    elseif distance >= 3 then
        if random <= 20 then
            goals:AddSubGoal(GOAL_COMMON_SidewayMove, sideway_move_life_close, TARGET_ENE_0, sideway_move_direction, sideway_move_desired_angle, true, true, IsGuard)
        elseif random <= 35 then
            goals:AddSubGoal(GOAL_COMMON_LeaveTarget, leave_target_life_close, TARGET_ENE_0, leave_target_stop_distance_close, TARGET_ENE_0, true, IsGuard)
        end
    elseif random <= 0 then
        goals:AddSubGoal(GOAL_COMMON_SidewayMove, sideway_move_life_close, TARGET_ENE_0, sideway_move_direction, sideway_move_desired_angle, true, true, IsGuard)
    elseif random <= 30 then
        goals:AddSubGoal(GOAL_COMMON_LeaveTarget, leave_target_life_close, TARGET_ENE_0, leave_target_stop_distance_close, TARGET_ENE_0, true, IsGuard)
    else
    end
end

Goal.Update = function (arg0, arg1, arg2)
    return Update_Default_NoSubGoal(arg0, arg1, arg2)
end
