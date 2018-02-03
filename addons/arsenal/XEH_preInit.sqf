#include "script_component.hpp"
#include "defines.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Arsenal
GVAR(modList) = ["","curator","kart","heli","mark","expansion","expansionpremium"];
/*
if (["ACE_Explosives"] call EFUNC(common,isModLoaded)) then {
    private _array = [
        [["ace_explosives_Range"], localize LSTRING(statExploRange), [false, true], [], [{}, {
            params ["_stat", "_config"];

            private _exploRangeStat = getNumber (_config >> _stat select 0);
            format ["%1m (%2ft)", _exploRangeStat, (_exploRangeStat / 0.3048) toFixed 1];
        }, {
            params ["", "_config"];

            (getNumber (_config >> "ace_explosives_Detonator"))  > 0
        }]]
    ];

    if (count ((GVAR(statsListRightPanel) select 7) select 0) <= 4) then {
        (GVAR(statsListRightPanel) select 7) select 0 append _array;
    } else {
        (GVAR(statsListRightPanel) select 7) pushBack _array;
    };
};

if (["ACE_Overpressure"] call EFUNC(common,isModLoaded)) then {
    private _array =[
        [["ace_overpressure_angle"], localize LSTRING(statBackblastAngle), [false, true], [], [{}, {
            params ["_stat", "_config"];

            private _blastAngleStat = getNumber (_config >> _stat select 0);
            format ["%1°", _blastAngleStat];
        }]],
        [["ace_overpressure_range"], localize LSTRING(statBackblastRange), [false, true], [], [{}, {
            params ["_stat", "_config"];

            private _blastRangeStat = getNumber (_config >> _stat select 0);
            format ["%1m (%2ft)", _blastRangeStat, (_blastRangeStat / 0.3048) toFixed 1];
        }]]
    ];

    if (count ((GVAR(statsListLeftPanel) select 2) select 0) <= 3) then {
        (GVAR(statsListLeftPanel) select 2) select 0 append _array;
    } else {
        (GVAR(statsListLeftPanel) select 2) pushBack _array;
    };
};

if (["ACE_Flashlights"] call EFUNC(common,isModLoaded)) then {
    private _array =[
        [["ACE_Flashlight_Colour"], localize LSTRING(statMapLightColor), [false, true], [], [{}, {
            params ["_stat", "_config"];

            getText (_config >> "itemInfo" >> "FlashLight" >> _stat select 0);
        }, {
            params ["_stat", "_config"];

            getText (_config >> "itemInfo" >> "FlashLight" >> _stat select 0) != ""
        }]]
    ];

    {
        if (count ((GVAR(statsListRightPanel) select _x) select 0) <= 4) then {
            (GVAR(statsListRightPanel) select _x) select 0 append _array;
        } else {
            (GVAR(statsListRightPanel) select _x) pushBack _array;
        };
    } forEach [1, 7];
};

if (["ACE_gforces"] call EFUNC(common,isModLoaded)) then {
    private _array =[
        [["ACE_GForceCoef"], localize LSTRING(statGReduction), [true, false], [[1, 0], [0.01, 1], false], [_fnc_otherBarStat, {}, {
            params ["_stat", "_config"];

            getNumber (_config >> _stat select 0) > 0
        }]]
    ];

    if (count ((GVAR(statsListLeftPanel) select 3) select 0) <= 4) then {
        (GVAR(statsListLeftPanel) select 3) select 0 append _array;
    } else {
        (GVAR(statsListLeftPanel) select 3) pushBack _array;
    };
};
*/

[QGVAR(camInverted), "CHECKBOX", localize LSTRING(invertCameraSetting), localize LSTRING(settingCategory), false] call CBA_Settings_fnc_init;
[QGVAR(enableModIcons), "CHECKBOX", [LSTRING(modIconsSetting), LSTRING(modIconsTooltip)], localize LSTRING(settingCategory), true] call CBA_Settings_fnc_init;
[QGVAR(fontHeight), "SLIDER", [LSTRING(fontHeightSetting), LSTRING(fontHeightTooltip)], localize LSTRING(settingCategory), [1, 10, 4.5, 1]] call CBA_Settings_fnc_init;

// Arsenal loadouts
[QGVAR(allowDefaultLoadouts), "CHECKBOX", [LSTRING(allowDefaultLoadoutsSetting), LSTRING(defaultLoadoutsTooltip)], localize LSTRING(settingCategory), true, true] call CBA_Settings_fnc_init;
[QGVAR(allowSharedLoadouts), "CHECKBOX", localize LSTRING(allowSharingSetting), localize LSTRING(settingCategory), true, true] call CBA_Settings_fnc_init;
[QGVAR(EnableRPTLog), "CHECKBOX", [LSTRING(printToRPTSetting), LSTRING(printToRPTTooltip)], localize LSTRING(settingCategory), false, false] call CBA_Settings_fnc_init;

[QGVAR(statsToggle), {
    params ["_display", "_showStats"];

    private _statsCtrlGroupCtrl = _display displayCtrl IDC_statsBox;
    private _statsPreviousPageCtrl = _display displayCtrl IDC_statsPreviousPage;
    private _statsNextPageCtrl = _display displayCtrl IDC_statsNextPage;
    private _statsCurrentPageCtrl = _display displayCtrl IDC_statsCurrentPage;

    private _statsButtonCtrl = _display displayCtrl IDC_statsButton;
    private _statsButtonCloseCtrl = _display displayCtrl IDC_statsButtonClose;

    {
        _x ctrlShow (GVAR(showStats) && {_showStats});
    } forEach [
        _statsCtrlGroupCtrl,
        _statsPreviousPageCtrl,
        _statsNextPageCtrl,
        _statsCurrentPageCtrl,
        _statsButtonCloseCtrl
    ];

    _statsButtonCtrl ctrlShow (!GVAR(showStats) && {_showStats})
}] call CBA_fnc_addEventHandler;

[QGVAR(statsButton), {
    _this call FUNC(buttonStats);
}] call CBA_fnc_addEventHandler;

[QGVAR(statsChangePage), {
    _this call FUNC(buttonStatsPage);
}] call CBA_fnc_addEventHandler;


[QGVAR(displayStats), {
    _this call FUNC(handleStats);
}] call CBA_fnc_addEventHandler;

ADDON = true;
