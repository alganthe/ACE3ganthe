#include "script_component.hpp"
#include "..\defines.hpp"

params ["_loadout"];

private _weaponCfg = configFile >> "CfgWeapons";
private _magCfg = configFile >> "CfgMagazines";
private _vehcCfg = configFile >> "CfgVehicles";
private _glassesCfg = configFile >> "CfgGlasses";
private _weaponsArray = GVAR(virtualItems) select 0;
private _accsArray = GVAR(virtualItems) select 1;

private _nullItemsAmount = 0;
private _unavailableItemsAmount = 0;

private _fnc_weaponCheck = {
    params ["_dataPath"];

    if (count _dataPath != 0) then {
        {
            if (_x isEqualType "") then {

                private _item = _x;

                if (_item != "") then {
                    if (isClass (_weaponCfg >> _item)) then {
                        if !(CHECK_WEAPON_OR_ACC) then {

                            _dataPath set [_forEachIndex, ""];
                            _unavailableItemsAmount = _unavailableItemsAmount + 1;
                        };
                    } else {

                        _dataPath set [_forEachIndex, ""];
                        _nullItemsAmount = _nullItemsAmount + 1;
                    };
                };

            } else {

                if (count _x != 0) then {
                    private _mag = _x select 0;

                    if (isClass (_magCfg >> _mag)) then {
                        if !(_mag in (GVAR(virtualItems) select 2)) then {

                            _dataPath set [_forEachIndex, []];
                            _unavailableItemsAmount = _unavailableItemsAmount + 1;
                        };
                    } else {

                        _dataPath set [_forEachIndex, []];
                        _nullItemsAmount = _nullItemsAmount + 1;
                    };
                };
            };
        } foreach _dataPath;
    };
};

for "_dataIndex" from 0 to 9 do {
    switch (_dataIndex) do {
        case 0;
        case 1;
        case 2;
        case 8: {
            [_loadout select _dataIndex] call _fnc_weaponCheck;
        };

        case 3;
        case 4;
        case 5: {
            private _containerArray = (_loadout select _dataIndex);

            if (count _containerArray != 0) then {

                _containerArray params ["_item", "_containerItems"];

                if (isClass (_vehcCfg >> _item) || {isClass (_weaponCfg >> _item)}) then {
                    if !(CHECK_CONTAINER) then {

                        TRACE_1("item unavailable", _item);
                        _loadout set [_dataIndex, []];
                        _unavailableItemsAmount = _unavailableItemsAmount + 1;
                    } else {

                        if (count _containerItems != 0) then {
                            {
                                private _currentIndex = _forEachIndex;

                                switch (count _x) do {
                                    case 2: {

                                        if ((_x select 0) isEqualType "") then {

                                            private _item = _x select 0;

                                            if (CLASS_CHECK_ITEM) then {
                                                if !(CHECK_CONTAINER_ITEMS) then {

                                                    TRACE_1("item unavailable", _item);
                                                    ((_loadout select _dataIndex) select 1) set [_currentIndex, []];
                                                    _unavailableItemsAmount = _unavailableItemsAmount + 1;
                                                };
                                            } else {

                                                TRACE_1("item null", _item);
                                                ((_loadout select _dataIndex) select 1) set [_currentIndex, []];
                                                _nullItemsAmount = _nullItemsAmount + 1;
                                            };
                                        } else {

                                            [(((_loadout select _dataIndex) select 1) select _currentIndex) select 0] call _fnc_weaponCheck;
                                        };
                                    };

                                    case 3: {
                                        private _item = _x select 0;

                                        if (isClass (_magCfg >> _item)) then {
                                            if (_item in (GVAR(virtualItems) select 3)) then {

                                                TRACE_1("item unavailable", _item);
                                                ((_loadout select _dataIndex) select 1) set [_currentIndex, []];
                                                _unavailableItemsAmount = _unavailableItemsAmount + 1;
                                            };
                                        } else {

                                            TRACE_1("item null", _item);
                                            ((_loadout select _dataIndex) select 1) set [_currentIndex, []];
                                            _nullItemsAmount = _nullItemsAmount + 1;
                                        };
                                    };
                                };
                            } foreach _containerItems;
                        };
                    };
                } else {

                    _loadout set [_dataIndex, []];
                    _nullItemsAmount = _nullItemsAmount + 1;
                };
            };
        };

        case 6: {
            private _item = _loadout select _dataIndex;

            if (_item != "") then {

                if (isClass (_weaponCfg >> _item)) then {

                    if !(_item in (GVAR(virtualItems) select 3)) then {

                        TRACE_1("item unavailable", _item);
                        _loadout set [_dataIndex, ""];
                        _unavailableItemsAmount = _unavailableItemsAmount + 1;
                    };
                } else {

                    TRACE_1("item null", _item);
                    _loadout set [_dataIndex, ""];
                    _nullItemsAmount = _nullItemsAmount + 1;
                };
            };
        };

        case 7: {
            private _item = _loadout select _dataIndex;

            if (_item != "") then {

                if (isClass (_glassesCfg >> _item)) then {

                    if !(_item in (GVAR(virtualItems) select 7)) then {

                        TRACE_1("item unavailable", _item);
                        _loadout set [_dataIndex, ""];
                        _unavailableItemsAmount = _unavailableItemsAmount + 1;
                    };
                } else {

                    TRACE_1("item null", _item);
                    _loadout set [_dataIndex, ""];
                    _nullItemsAmount = _nullItemsAmount + 1;
                };
            };
        };

        case 9: {
            for "_subIndex" from 0 to 4 do {
                private _item = (_loadout select _dataIndex) select _subIndex;

                if (_item != "") then {

                    if (isClass (_weaponCfg >> _item)) then {

                        if !(CHECK_ASSIGNED_ITEMS) then {

                            TRACE_1("item unavailable", _item);
                            (_loadout select _dataIndex) set [_subIndex, ""];
                            _unavailableItemsAmount = _unavailableItemsAmount + 1;
                        };
                    } else {

                        TRACE_1("item null", _item);
                        (_loadout select _dataIndex) set [_subIndex, ""];
                        _nullItemsAmount = _nullItemsAmount + 1;
                    };
                };
            };
        };
    };
};

[_loadout, _nullItemsAmount, _unavailableItemsAmount]