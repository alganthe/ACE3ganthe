#include "script_component.hpp"
#include "..\defines.hpp"

private _nextAction = "";

switch (GVAR(currentLeftPanel)) do {

    case IDC_buttonPrimaryWeapon : {
        _nextAction = ["Civil", "PrimaryWeapon"] select ((GVAR(currentItems) select 0) != "");
    };
    case IDC_buttonSecondaryWeapon : {
        _nextAction = ["Civil", "SecondaryWeapon"] select (GVAR(currentItems) select 1 != "");
    };
    case IDC_buttonHandgun : {
        _nextAction = ["Civil", "HandGunOn"] select (GVAR(currentItems) select 2 != "");
    };
    case IDC_buttonHeadgear;
    case IDC_buttonUniform;
    case IDC_buttonVest;
    case IDC_buttonBackpack;
    case IDC_buttonGoggles;
    case IDC_buttonNVG : {
        _nextAction = "Stand";
    };
    case IDC_buttonBinoculars : {
        _nextAction = ["Civil", "Binoculars"] select (GVAR(currentItems) select 9 != "");
    };
    case IDC_buttonInsigna : {
        if ((animationState GVAR(center)) find "salute" == -1) then {
            _nextAction = "Salute";
        };
    };
    case IDC_buttonVoice : {
        GVAR(center) directSay "CuratorObjectPlaced";
    };
};

if (_nextAction != GVAR(currentAction)) then {
    switch (_nextAction) do {
        case "PrimaryWeapon": {
            GVAR(selectedWeaponType) = 0;
        };
        case "SecondaryWeapon": {
            GVAR(selectedWeaponType) = 1;
        };
        case "HandGunOn": {
            GVAR(selectedWeaponType) = 2;
        };
    };

    if (simulationEnabled GVAR(center)) then {
        GVAR(center) playActionNow _nextAction;
    } else {
        GVAR(center) switchAction _nextAction;
    };
};