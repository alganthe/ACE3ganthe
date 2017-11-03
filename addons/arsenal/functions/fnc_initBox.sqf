#include "script_component.hpp"
#include "..\defines.hpp"

params [["_object", objNull, [objNull]], ["_items", true, [[], true]], ["_global", true, [true]]];

if (isNull _object) exitWith {};

if (isNil QGVAR(EHIDArray)) then {
    GVAR(EHIDArray) = [];
};

if (_global && {isMultiplayer} && {{_object in _x} count GVAR(EHIDArray) == 0}) then {

    private _ID = [QGVAR(initBox), [_object, _items, false]] call CBA_fnc_globalEventJIP;
    [_ID, _object] call CBA_fnc_removeGlobalEventJIP;
    
    GVAR(EHIDArray) pushBack [_ID, _object];
    publicVariable QGVAR(EHIDArray);
} else {

    if ({(_x select 0) select 0 isEqualTo QGVAR(interaction)} count (_object getVariable [QEGVAR(interact_menu,actions), []]) == 0) then {

        private _action = [QGVAR(interaction), "arsenal", "", {
            params ["_target", "_player"];

            [{[_this select 0, _this select 1] call FUNC(openBox)}, [_target, _player]] call CBA_fnc_execNextFrame;
        }, 
        {
            params ["_target", "_player"];
            
            [_player, _target, ["isNotSwimming", "isNotCarrying", "isNotDragging", "notOnMap", "isNotEscorting", "isNotOnLadder"]] call EFUNC(common,canInteractWith)
        }, {},[]] call EFUNC(interact_menu,createAction);
        [_object, 0, ["ACE_MainActions"], _action] call EFUNC(interact_menu,addActionToObject);

        [_object, _items, false] call FUNC(addVirtualItems);
    };
};

