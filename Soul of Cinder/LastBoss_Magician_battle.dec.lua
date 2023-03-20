--Hopefully more readable

RegisterTableGoal(GOAL_LastBoss_Magician_Battle, "LastBoss_Magician")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_LastBoss_Magician_Battle, true)

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
    local low_hp_modifier
    if actor:GetHpRate(TARGET_SELF) <= 0.3 then
        low_hp_modifier = 2
    else
        low_hp_modifier = 1
    end

    local is_not_silenced
    --SpEffect 103581000 = Vow of Silence
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        is_not_silenced = 0
    else
        is_not_silenced = 1
    end

    --Number(2) is basically a value stored in cinder, it goes up every time cinder attacks- by a different amount for each attack
    --you can mentally replace Number(2) with "how much has cinder attacked/how much will he want to phase change"

    local phase_change_chance --if this value is at least 100, cinder will phase change
    local close_to_phase_change_modifier --the closer he is to phase changing, the higher this is
    if actor:GetNumber(2) >= 150 then
        phase_change_chance = actor:GetRandam_Int(100, 120)
        close_to_phase_change_modifier = 50 * low_hp_modifier
    elseif actor:GetNumber(2) >= 100 then
        phase_change_chance = actor:GetRandam_Int(90, 120)
        close_to_phase_change_modifier = 40 * low_hp_modifier
    elseif actor:GetNumber(2) >= 75 then
        phase_change_chance = actor:GetRandam_Int(60, 120)
        close_to_phase_change_modifier = 30 * low_hp_modifier
    elseif actor:GetNumber(2) >= 50 then
        phase_change_chance = actor:GetRandam_Int(10, 110)
        close_to_phase_change_modifier = 10 * low_hp_modifier
    else
        phase_change_chance = actor:GetRandam_Int(1, 10)
        close_to_phase_change_modifier = 0
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
    local phase_sword_weight
    local phase_lance_weight
    local phase_curved_weight
    if actor:HasSpecialEffectId(TARGET_SELF, 12120) then --if has soul mass generator then:
        phase_sword_weight = 1.5
        phase_lance_weight = 1
        phase_curved_weight = 2
    else
        phase_sword_weight = 1
        phase_lance_weight = 1.7
        phase_curved_weight = 1
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
    if phase_change_chance >= 100 then
        probabilities[30] = 100 * phase_sword_weight
        probabilities[31] = 100 * phase_lance_weight * first_time_lance_modifier
        probabilities[32] = 100 * phase_curved_weight * first_time_curved_modifier
    elseif distance >= 15 then
        probabilities[1] = 40
        probabilities[2] = 10
        probabilities[3] = 30 * is_not_buffed
        probabilities[4] = 0 * is_not_silenced
        probabilities[5] = 20 * close_to_phase_change_modifier * is_not_silenced
    elseif distance >= 10 then
        probabilities[1] = 20
        probabilities[2] = 20
        probabilities[3] = 40 * is_not_buffed
        probabilities[4] = 0 * is_not_silenced
        probabilities[5] = 20 * close_to_phase_change_modifier * is_not_silenced
    elseif distance >= 5 then
        probabilities[1] = 10
        probabilities[2] = 30
        probabilities[3] = 45 * is_not_buffed
        probabilities[4] = 5 * is_not_silenced
        probabilities[5] = 10 * close_to_phase_change_modifier * is_not_silenced
    else
        probabilities[1] = 5
        probabilities[2] = 15
        probabilities[3] = 45 * is_not_buffed
        probabilities[4] = 25 * is_not_silenced
        probabilities[5] = 10 * close_to_phase_change_modifier * is_not_silenced
    end
    probabilities[3] = SetCoolTime(actor, goals, 3003, 30, probabilities[3], 0)
    probabilities[4] = SetCoolTime(actor, goals, 3004, 8, probabilities[4], 0)
    probabilities[5] = SetCoolTime(actor, goals, 3009, 20, probabilities[5], 0)
    acts[1] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act01)
    acts[2] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act02)
    acts[3] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act03)
    acts[4] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act04)
    acts[5] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act05)
    acts[20] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act20)
    acts[30] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act30)
    acts[31] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act31)
    acts[32] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act32)
    acts[33] = REGIST_FUNC(actor, goals, LastBoss_Magician_Act33)
    Common_Battle_Activate(actor, goals, probabilities, acts, REGIST_FUNC(actor, goals, LastBoss528000_ActAfter_AdjustSpace), f2_local0)
end

--GetMapHitRadius gets cinder's hitbox radius, which is 0.7.

--Start with soul spear and combo
function LastBoss_Magician_Act01(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local stop_distance = 30 - actor:GetMapHitRadius(TARGET_SELF)
    local can_run_distance = 30 - actor:GetMapHitRadius(TARGET_SELF) + 5
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    local silenced_wants_phase_change_modifier
    local is_not_silenced
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        silenced_wants_phase_change_modifier = 10
        is_not_silenced = 0
    else
        silenced_wants_phase_change_modifier = 1
        is_not_silenced = 1
    end
    if distance <= 12 - actor:GetMapHitRadius(TARGET_SELF) then
        if combo_length_random <= 30 then
            actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3000, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
        else
            actor:SetNumber(2, actor:GetNumber(2) + 15 * silenced_wants_phase_change_modifier)
            if random <= 30 then
                goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, 30 - actor:GetMapHitRadius(TARGET_SELF))
                goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, success_distance)
            else
                goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3000, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
                goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
            end
        end
    elseif combo_length_random <= 30 then
        actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3000, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 15 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, 30 - actor:GetMapHitRadius(TARGET_SELF))
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, success_distance)
    end
    GetWellSpace_Odds = 100 * is_not_silenced
    return GetWellSpace_Odds
end

--Farron hail (shotgun blast)
function LastBoss_Magician_Act02(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local stop_distance = 12 - actor:GetMapHitRadius(TARGET_SELF)
    local can_run_distance = 12 - actor:GetMapHitRadius(TARGET_SELF) + 4
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    local silenced_wants_phase_change_modifier
    local is_not_silenced
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        silenced_wants_phase_change_modifier = 10
        is_not_silenced = 0
    else
        silenced_wants_phase_change_modifier = 1
        is_not_silenced = 1
    end
    if distance <= 3 then
        actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
    elseif distance <= 10 then
        if combo_length_random <= 65 then
            actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3001, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
        else
            actor:SetNumber(2, actor:GetNumber(2) + 15 * silenced_wants_phase_change_modifier)
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
        end
    elseif combo_length_random <= 30 then
        actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3001, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 15 * silenced_wants_phase_change_modifier)
        if random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3001, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3001, TARGET_ENE_0, 30 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100 * is_not_silenced
    return GetWellSpace_Odds
end

--Homing soul mass
function LastBoss_Magician_Act03(actor, goals, _)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    local silenced_wants_phase_change_modifier
    local is_not_silenced
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        silenced_wants_phase_change_modifier = 10
        is_not_silenced = 0
    else
        silenced_wants_phase_change_modifier = 1
        is_not_silenced = 1
    end
    actor:SetNumber(2, actor:GetNumber(2) + 30 * silenced_wants_phase_change_modifier)
    goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3003, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    GetWellSpace_Odds = 100 * is_not_silenced
    return GetWellSpace_Odds
end

--Soul Greatsword
function LastBoss_Magician_Act04(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local stop_distance = 5 - actor:GetMapHitRadius(TARGET_SELF)
    local can_run_distance = 5 - actor:GetMapHitRadius(TARGET_SELF) + 2
    Approach_Act_Flex(actor, goals, stop_distance, can_run_distance, 999, 100, 0, 3, 5)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
    local turn_time_before = 0
    local front_decision_angle = 0
    local combo_length_random = actor:GetRandam_Int(1, 100)
    local random = actor:GetRandam_Int(1, 100)
    local silenced_wants_phase_change_modifier
    local is_not_silenced
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        silenced_wants_phase_change_modifier = 10
        is_not_silenced = 0
    else
        silenced_wants_phase_change_modifier = 1
        is_not_silenced = 1
    end
    if distance <= 2 then
        actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 6001, TARGET_ENE_0, 12 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3004, TARGET_ENE_0, success_distance)
    elseif combo_length_random <= 40 then
        actor:SetNumber(2, actor:GetNumber(2) + 8 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, 3004, TARGET_ENE_0, success_distance, turn_time_before, front_decision_angle)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 15 * silenced_wants_phase_change_modifier)
        if random <= 40 then
            goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3004, TARGET_ENE_0, 30 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3000, TARGET_ENE_0, success_distance)
        else
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3004, TARGET_ENE_0, 5 - actor:GetMapHitRadius(TARGET_SELF))
            goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3004, TARGET_ENE_0, success_distance)
        end
    end
    GetWellSpace_Odds = 100 * is_not_silenced
    return GetWellSpace_Odds
end

--Soul Stream
function LastBoss_Magician_Act05(actor, goals, _)
    local distance = actor:GetDist(TARGET_ENE_0)
    local turn_time_before = 0
    local front_decision_angle = 0
    actor:GetRandam_Int(1, 100)
    actor:GetRandam_Int(1, 100)
    local silenced_wants_phase_change_modifier
    local is_not_silenced
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        silenced_wants_phase_change_modifier = 10
        is_not_silenced = 0
    else
        silenced_wants_phase_change_modifier = 1
        is_not_silenced = 1
    end
    if distance <= 5 - actor:GetMapHitRadius(TARGET_SELF) then
        actor:SetNumber(2, actor:GetNumber(2) + 40 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_ComboTunable_SuccessAngle180, 10, 3004, TARGET_ENE_0, 100 - actor:GetMapHitRadius(TARGET_SELF), turn_time_before, front_decision_angle)
        goals:AddSubGoal(GOAL_COMMON_ComboFinal, 10, 3009, TARGET_ENE_0, SuccessDist)
    else
        actor:SetNumber(2, actor:GetNumber(2) + 40 * silenced_wants_phase_change_modifier)
        goals:AddSubGoal(GOAL_COMMON_ComboAttackTunableSpin, 10, 3009, TARGET_ENE_0, SuccessDist, turn_time_before, front_decision_angle)
    end
    GetWellSpace_Odds = 100 * is_not_silenced
    return GetWellSpace_Odds
end

--Change to sword
function LastBoss_Magician_Act30(actor, goals, _)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
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
function LastBoss_Magician_Act31(actor, goals, _)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
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
function LastBoss_Magician_Act32(actor, goals, _)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
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
function LastBoss_Magician_Act33(actor, goals, _)
    local success_distance = 100 - actor:GetMapHitRadius(TARGET_SELF)
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
    local is_not_silenced
    if actor:HasSpecialEffectId(TARGET_SELF, 103581000) then
        is_not_silenced = 0
    else
        is_not_silenced = 1
    end
    if actor:IsInterupt(INTERUPT_Shoot) then --Bullet (often ranged attack) "input read"
        if distance >= 15 and random <= 50 and is_not_silenced >= 1 then
            actor:SetNumber(2, actor:GetNumber(2) + 8)
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 3000, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 5 and random <= 40 and is_not_silenced >= 1 then
            actor:SetNumber(2, actor:GetNumber(2) + 8)
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 3001, TARGET_ENE_0, 20, 0, 0)
            return true
        elseif distance >= 2 and random <= 50 and is_not_silenced >= 1 then
            actor:SetNumber(2, actor:GetNumber(2) + 8)
            goals:ClearSubGoal()
            goals:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 2, 3004, TARGET_ENE_0, 20, 0, 0)
            return true
        end
    end
    return false
end
