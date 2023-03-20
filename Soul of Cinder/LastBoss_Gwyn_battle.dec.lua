--Hopefully more readable

RegisterTableGoal(GOAL_LastBoss_Gwyn_Battle, "LastBoss_Gwyn")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_LastBoss_Gwyn_Battle, true)

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
    actor:DeleteObserveSpecialEffectAttribute(TARGET_SELF, 5025) --Seemingly remained from some scrapped dynamic combo, ignore
    local distance = actor:GetDist(TARGET_ENE_0)
    actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)

    --Number(0) and Number(1) are much like Number(2) from the first phase, increasing for each combo cinder does
    --Except instead of representing how much cinder wants to change phases, Number(0) is for the 5-hit combo, and Number(1) is for the lightning storm
    --(Also the phase change number had graduality, these have absolute thresholds, if they're at 100 then he will do them, otherwise he won't)

    --SpEffect 12123 = a SpEffect applied in his phase change animation (to guarantee he will do the 5-hit combo act after transitioning), this effect lasts 10 seconds
    if actor:GetNumber(0) >= 100 or actor:HasSpecialEffectId(TARGET_SELF, 12123) then
        probabilities[12] = 100
    elseif actor:GetNumber(1) >= 100 and hp_rate <= 0.75 then
        probabilities[11] = 100
    elseif distance >= 15 then
        probabilities[1] = 10
        probabilities[2] = 0
        probabilities[3] = 15
        probabilities[4] = 15
        probabilities[5] = 5
        probabilities[6] = 35
        probabilities[8] = 0
        probabilities[9] = 0
        probabilities[10] = 20
    elseif distance >= 10 then
        probabilities[1] = 5
        probabilities[2] = 0
        probabilities[3] = 20
        probabilities[4] = 20
        probabilities[5] = 10
        probabilities[6] = 20
        probabilities[8] = 0
        probabilities[9] = 0
        probabilities[10] = 25
    elseif distance >= 6 then
        probabilities[1] = 10
        probabilities[2] = 0
        probabilities[3] = 20
        probabilities[4] = 20
        probabilities[5] = 10
        probabilities[6] = 10
        probabilities[8] = 0
        probabilities[9] = 0
        probabilities[10] = 30
    elseif distance >= 2 then
        probabilities[1] = 15
        probabilities[2] = 10
        probabilities[3] = 20
        probabilities[4] = 20
        probabilities[5] = 15
        probabilities[6] = 0
        probabilities[8] = 0
        probabilities[9] = 20
        probabilities[10] = 0
    else
        probabilities[1] = 25
        probabilities[2] = 20
        probabilities[3] = 0
        probabilities[4] = 0
        probabilities[5] = 20
        probabilities[6] = 0
        probabilities[8] = 20
        probabilities[9] = 20
        probabilities[10] = 0
    end
    probabilities[8] = SetCoolTime(actor, goals, 3021, 8, probabilities[8], 0)
    probabilities[10] = SetCoolTime(actor, goals, 3023, 8, probabilities[10], 0)
    acts[1] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act01)
    acts[2] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act02)
    acts[3] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act03)
    acts[4] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act04)
    acts[5] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act05)
    acts[6] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act06)
    acts[8] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act08)
    acts[9] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act09)
    acts[10] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act10)
    acts[11] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act11)
    acts[12] = REGIST_FUNC(actor, goals, LastBoss_Gwyn_Act12)
    Common_Battle_Activate(actor, goals, probabilities, acts, REGIST_FUNC(actor, goals, LastBoss528000_ActAfter_AdjustSpace), f2_local0)
end

--GetMapHitRadius gets cinder's hitbox radius, which is 0.7.

--Start with right to left one handed swing and combo
function LastBoss_Gwyn_Act01(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)
    if combo_length_random <= 0 then
        actor:SetNumber(0, actor:GetNumber(0) + 4)
        actor:SetNumber(1, actor:GetNumber(1) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3000, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif combo_length_random <= 60 then
        actor:SetNumber(0, actor:GetNumber(0) + 8)
        actor:SetNumber(1, actor:GetNumber(1) + 4)
        if random <= 60 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3013, TARGET_ENE_0, success_distance)
        end
    else
        actor:SetNumber(0, actor:GetNumber(0) + 12)
        actor:SetNumber(1, actor:GetNumber(1) + 8)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3001, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3002, TARGET_ENE_0, success_distance)
        elseif random <= 60 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3001, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3003, TARGET_ENE_0, success_distance)
        elseif random <= 80 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3013, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3014, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3013, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3016, TARGET_ENE_0, success_distance)
        end
    end
    if hp_rate >= 0.5 then
        GetWellSpace_Odds = 70
    else
        GetWellSpace_Odds = 30
    end
    return GetWellSpace_Odds
end

--Grab
function LastBoss_Gwyn_Act02(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 4.5 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 4.5 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:GetHpRate(TARGET_SELF)
    actor:SetNumber(0, actor:GetNumber(0) + 8)
    actor:SetNumber(1, actor:GetNumber(1) + 8)
    goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3006, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 70
    return GetWellSpace_Odds
end

--Start with a lunging thrust and combo
function LastBoss_Gwyn_Act03(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 13 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 13 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)
    if actor:GetRandam_Int(1, 100) <= 25 then
        actor:SetNumber(0, actor:GetNumber(0) + 8)
        actor:SetNumber(1, actor:GetNumber(1) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3008, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(0, actor:GetNumber(0) + 12)
        actor:SetNumber(1, actor:GetNumber(1) + 8)
        if random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3008, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3012, TARGET_ENE_0, success_distance)
        elseif random <= 70 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3008, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3009, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3008, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3006, TARGET_ENE_0, success_distance)
        end
    end
    if hp_rate >= 0.5 then
        GetWellSpace_Odds = 70
    else
        GetWellSpace_Odds = 30
    end
    return GetWellSpace_Odds
end

--Start with a one handed jump swing and combo
function LastBoss_Gwyn_Act04(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 12.5 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 12.5 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)
    if actor:GetRandam_Int(1, 100) <= 35 then
        actor:SetNumber(0, actor:GetNumber(0) + 10)
        actor:SetNumber(1, actor:GetNumber(1) + 5)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3010, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(0, actor:GetNumber(0) + 15)
        actor:SetNumber(1, actor:GetNumber(1) + 10)
        if random <= 65 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3010, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3010, TARGET_ENE_0, 6.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, success_distance)
        end
    end
    if hp_rate >= 0.5 then
        GetWellSpace_Odds = 70
    else
        GetWellSpace_Odds = 30
    end
    return GetWellSpace_Odds
end

--Start with right to left two handed swing and combo
function LastBoss_Gwyn_Act05(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 6 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    actor:GetHpRate(TARGET_SELF)
    if combo_length_random <= 0 then
        actor:SetNumber(0, actor:GetNumber(0) + 5)
        actor:SetNumber(1, actor:GetNumber(1) + 5)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3012, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif combo_length_random <= 60 then
        actor:SetNumber(0, actor:GetNumber(0) + 10)
        actor:SetNumber(1, actor:GetNumber(1) + 10)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3011, TARGET_ENE_0, success_distance)
        elseif random <= 65 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3013, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, 6.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3015, TARGET_ENE_0, success_distance)
        end
    else
        actor:SetNumber(0, actor:GetNumber(0) + 15)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
        if random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3013, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3014, TARGET_ENE_0, success_distance)
        elseif random <= 80 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3013, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3016, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3012, TARGET_ENE_0, 6.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, 3015, TARGET_ENE_0, 6 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3012, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 50
    return GetWellSpace_Odds
end

--Two handed jump swing
function LastBoss_Gwyn_Act06(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 17 - actor:GetMapHitRadius(TARGET_SELF) - 1
    local can_run_distance = 17 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:SetNumber(0, actor:GetNumber(0) + 15)
    actor:SetNumber(1, actor:GetNumber(1) + 10)
    goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3018, TARGET_ENE_0, 20 - actor:GetMapHitRadius(TARGET_SELF), 0, 0)
    if actor:GetHpRate(TARGET_SELF) >= 0.5 then
        GetWellSpace_Odds = 70
    else
        GetWellSpace_Odds = 50
    end
    return GetWellSpace_Odds
end

--Start with kick and combo
function LastBoss_Gwyn_Act08(actor, goals, _)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    actor:GetHpRate(TARGET_SELF)
    if actor:GetRandam_Int(1, 100) <= 20 then
        actor:SetNumber(0, actor:GetNumber(0) + 4)
        actor:SetNumber(1, actor:GetNumber(1) + 4)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3021, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(0, actor:GetNumber(0) + 6)
        actor:SetNumber(1, actor:GetNumber(1) + 6)
        if random <= 30 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3021, TARGET_ENE_0, 2 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3021, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3021, TARGET_ENE_0, 4.5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3006, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
end

--Start with lightning stake and combo
function LastBoss_Gwyn_Act09(actor, goals, _)
    actor:GetDist(TARGET_ENE_0)
    local stop_distance = 2.5 - actor:GetMapHitRadius(TARGET_SELF) + 1
    local can_run_distance = 2.5 - actor:GetMapHitRadius(TARGET_SELF) + 1
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    actor:GetHpRate(TARGET_SELF)
    if actor:GetRandam_Int(1, 100) <= 40 then
        actor:SetNumber(0, actor:GetNumber(0) + 0)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3022, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(0, actor:GetNumber(0) + 5)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
        if random <= 50 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3022, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3014, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3022, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3016, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 50
    return GetWellSpace_Odds
end

--Lightning spear
function LastBoss_Gwyn_Act10(actor, goals, _)
    local stop_distance = 100 - actor:GetMapHitRadius(TARGET_SELF) + 1
    local can_run_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local random = actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)
    if actor:GetDist(TARGET_ENE_0) <= 10 then
        actor:SetNumber(0, actor:GetNumber(0) + 0)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3023, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    elseif random <= 60 then
        actor:SetNumber(0, actor:GetNumber(0) + 0)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3023, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(0, actor:GetNumber(0) + 0)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3023, TARGET_ENE_0, 100 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3023, TARGET_ENE_0, success_distance)
    end
    if hp_rate >= 0.5 then
        GetWellSpace_Odds = 70
    else
        GetWellSpace_Odds = 50
    end
    return GetWellSpace_Odds
end

--Lightning storm
function LastBoss_Gwyn_Act11(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    actor:GetHpRate(TARGET_SELF)
    if distance <= 10 then
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6001, TARGET_ENE_0, 100 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3024, TARGET_ENE_0, 100, turn_time_before, front_decision_angle)
        actor:SetNumber(0, actor:GetNumber(0) + 15)
        actor:SetNumber(1, 20)
    else
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3024, TARGET_ENE_0, 100, turn_time_before, front_decision_angle)
        actor:SetNumber(0, actor:GetNumber(0) + 15)
        actor:SetNumber(1, 20)
    end
    local leave_target_life = actor:GetRandam_Float(3, 3)
    local leave_target_stop_distance = distance + actor:GetRandam_Float(20, 20)
    goals:AddSubGoal(GOAL_COMMON_LeaveTarget, leave_target_life, TARGET_ENE_0, leave_target_stop_distance, TARGET_ENE_0, true, IsGuard)
    GetWellSpace_Odds = 0
    return GetWellSpace_Odds
end

--5-hit combo
function LastBoss_Gwyn_Act12(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local stop_distance = 5 - actor:GetMapHitRadius(TARGET_SELF)
    local can_run_distance = 5 - actor:GetMapHitRadius(TARGET_SELF)
    local success_distance = 20 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_SELF)
    if distance <= 5 - actor:GetMapHitRadius(TARGET_SELF) then
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3030, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
        actor:SetNumber(0, 20)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
    elseif distance <= 13 - actor:GetMapHitRadius(TARGET_SELF) - 2 then
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3008, TARGET_ENE_0, 100, turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3030, TARGET_ENE_0, success_distance)
        actor:SetNumber(0, 20)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
    elseif distance <= 17 - actor:GetMapHitRadius(TARGET_SELF) - 2 then
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3018, TARGET_ENE_0, 100, turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3030, TARGET_ENE_0, success_distance)
        actor:SetNumber(0, 20)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
    else
        Approach_Act_Flex(actor, goals, stop_distance + 10, can_run_distance, 999, 100, 0, 3, 5)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3018, TARGET_ENE_0, 100, turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3030, TARGET_ENE_0, success_distance)
        actor:SetNumber(0, 20)
        actor:SetNumber(1, actor:GetNumber(1) + 15)
    end
    local leave_target_life = actor:GetRandam_Float(1.5, 1.5)
    local leave_target_stop_distance = distance + actor:GetRandam_Float(15, 15)
    if hp_rate >= 0.2 then --fromsoft trolling low damage runs
        goals:AddSubGoal(GOAL_COMMON_LeaveTarget, leave_target_life, TARGET_ENE_0, leave_target_stop_distance, TARGET_ENE_0, true, IsGuard)
    else
    end
    GetWellSpace_Odds = 0
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
    local should_react_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    local hp_rate = actor:GetHpRate(TARGET_ENE_0)
    if actor:IsInterupt(INTERUPT_Shoot) then --Bullet (often ranged attack) "input read"
        if distance >= 20 and should_react_random <= 100 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 12 and should_react_random <= 50 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 5 and should_react_random <= 30 then
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 6000, TARGET_ENE_0, 20, 0, 0)
            return true
        end
    end
    if actor:IsInterupt(INTERUPT_AIGuardBroken) then --When cinder detects a guard break then:
        actor:SetNumber(0, actor:GetNumber(0) + 25)
        actor:SetNumber(1, actor:GetNumber(1) + 25)
    end
    if hp_rate <= 0.5 then
        should_react_random = should_react_random * 2
    else
        should_react_random = should_react_random * 1
    end
    if actor:IsInterupt(INTERUPT_SuccessThrow) then --When cinder successfully grabbed then:
        actor:SetNumber(0, actor:GetNumber(0) + 20)
        actor:SetNumber(1, actor:GetNumber(1) + 5)
        if should_react_random >= 60 then
            if random <= 50 then
                goals:ClearSubGoal()
                goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 7, 3025, TARGET_ENE_0, 20 - actor:GetMapHitRadius(TARGET_SELF), 0, 0)
                return true
            else
                goals:ClearSubGoal()
                goals:AddSubGoal(GOAL_COMMON_ComboRepeat, 7, 3026, TARGET_ENE_0, 20 - actor:GetMapHitRadius(TARGET_SELF), 0, 0)
                return true
            end
        end
    end
    return false
end
