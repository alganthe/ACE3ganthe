#include "script_component.hpp"
#include "..\defines.hpp"

params ["", "_args"];
_args params ["_display"];

["ace_arsenal"] call bis_fnc_startloadingscreen;

//--------------- General vars
if (isNil QGVAR(center)) then {
    GVAR(center) = player;
};

GVAR(mouseButtonState) = [[],[]];
if (isNil QGVAR(mode)) then {
    GVAR(mode) = 1;
};

if (isNil QGVAR(virtualItems)) then {
    GVAR(virtualItems) = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []];
};

for "_index" from 0 to 10 do {
    private _array = (LIST_DEFAULTS select _index) select {!(_x isEqualTo "")};

    if !(_array isEqualTo []) then {
        {(GVAR(virtualItems) select _index) pushBackUnique _x} foreach _array  ;
    };
};

GVAR(selectedWeaponType) = switch true do {
    case (currentWeapon GVAR(center) == primaryWeapon GVAR(center)): {0};
    case (currentWeapon GVAR(center) == secondaryWeapon GVAR(center)): {1};
    case (currentWeapon GVAR(center) == handgunWeapon GVAR(center)): {2};
    default {-1};
};

//--------------- Fade out unused elements
private _mouseBlockCtrl = _display displayCtrl IDC_mouseBlock;
_mouseBlockCtrl ctrlEnable false;

{
    _x = _display displayCtrl _x;

    _x ctrlSetFade 1;
    _x ctrlShow false;
    _x ctrlCommit 0;
} foreach [
    IDC_blockRightFrame, 
    IDC_blockRighttBackground,
    IDC_loadIndicator,
    IDC_rightTabContent,
    IDC_sortRightTab,
    RIGHT_PANEL_ACC_IDCS,
    RIGHT_PANEL_ITEMS_IDCS,
    RIGHT_PANEL_REMOVE_IDCS,
    IDC_rightSearchbar
];

//--------------- Prepare the left panel
GVAR(currentLeftPanel) = nil;
GVAR(currentRightPanel) = nil;

if (GVAR(mode) != 0) then {
    {
        _x = _display displayCtrl _x;

        _x ctrlSetFade 1;
        _x ctrlShow false;
        _x ctrlCommit 0;
    } foreach [
        IDC_buttonFace,
        IDC_buttonVoice,
        IDC_buttonInsigna
    ];
};

[_display, _display displayCtrl IDC_buttonPrimaryWeapon] call FUNC(populatePanel);

//--------------- Camera prep
cutText ["","plain"];
showCommandingMenu "";

GVAR(cameraView) = cameraView;
player switchCamera "internal";
showHUD false;

private _mouseAreaCtrl = _display displayCtrl IDC_mouseArea;
ctrlSetFocus _mouseAreaCtrl;

//--------------- Init camera
GVAR(cameraPosition) = [5,0,0,[0,0,0.85]];

GVAR(cameraHelper) = createAgent ["Logic", position GVAR(center) ,[] ,0 ,"none"];
GVAR(cameraHelper) attachTo [GVAR(center), GVAR(cameraPosition) select 3, ""];

GVAR(camera) = "camera" camCreate position GVAR(center);
GVAR(camera) cameraEffect ["internal","back"];
GVAR(camera) camPrepareFocus [-1,-1];
GVAR(camera) camPrepareFov 0.35;
GVAR(camera) camCommitPrepared 0;

showCinemaBorder false;
["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;

//--------------- Reset camera pos
[nil, [controlNull,0,0]] call FUNC(handleMouse);
GVAR(camPosUpdateHandle) = addMissionEventHandler ["draw3D",{ [] call FUNC(updateCamPos) }];

//--------------- End loading screen
["ace_arsenal"] call bis_fnc_endloadingscreen;
