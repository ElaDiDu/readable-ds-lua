# Explaining some of dark souls' AI

## First of all, how to read the AI in general: 

- The Goal.Intiliaze function is executed when the AI is created.
- The Goal.Activate function is executed when the AI has no sub-goals, or in other words, when the AI has nothing to do (usually after after finishing an attack, or after making some distance). 
Sub-goals can be "do attack x", "turn left", "back off until 2 meters from target" etc.
- The Goal.Interrupt function is used as the "reaction" function. In here there will be all the input reads, such as dodging when the target creates a bullet (i.e using a spell or shooting a bow), when they should parry, etc.


The Activate function is usually the most relevant one, there the most prominent thing is the "probabilities" array. 
Reading it is simple enough, the index is the act number and the value is the weight for doing said act.
For example:
```
probabilities[1] = 10
probabilities[2] = 120
probabilities[5] = 30
```
This means that Act01 has weight of 10, Act02 weight of 120, Act05 weight of 30. At the end of the function one act will be chosen at random according to these weights.


Below the Activate function you'll find all the acts and what they actually do (e.g "Approach player and queue combo").
In every act function you'll also see a number returned (often referred to as GetWellSpace_Odds), this is (in percentages) how likely the entity is to go into their AfterAttackAct after executing the act.
Meaning if this is 100 for some act you'll probably see the entity idle/wander around (as that is usually what's in the AfterAttackAct for bosses) after executing said act.


## Check this community made explanation on many of the helper functions and sub-goals used in the AIs (made by the modding community), if you see a function whose name doesn't clarify its purpose, go here and CTRL + F:
https://docs.google.com/spreadsheets/d/1_tvSopHY_A_s70a_VO9xzX78fN7ig1oKJihuDjWDB-g


Even though I try to shortly describe what every act does, sometimes fully explaining is cumbersome so just look at the code and use the animation files I provided for visual reference.
Other helpful things to know:
- TARGET_ENE_0 is the entity's target, usually you! But possibly a summon or a different entity.
- GetMapHitRadius(entity) gets the entity's hitbox radius as defined in NPCParam.
- InsideDir(actor, goals, startDegree, degreeRange), basically just IsInsideTarget except the degrees can wrap around and it assumes target = TARGET_ENE_0?


Non-attacks animation ids:
- 6000 = Dodge forwards
- 6001 = Dodge backwards
- 6002 = Dodge left
- 6003 = Dodge right


I tried not to change the logic at all, just in case there's something I don't know. So you may see an impossible if statement or a useless function call here and there.


I want to make it clear most of the heavy lifting was by DSLuaDecompiler, from [this](https://github.com/nex3/DSLuaDecompiler) fork.
