class CfgACEArsenalStats {
    class statBase;
    class hearingProtection: statBase {
        scope = 2;
        priority = 2;
        stats[]= {"ACE_hearing_protection"};
        displayName= CSTRING(statHearingProtection);
        showBar = 1;
        barStatement = QUOTE([ARR_3((_this select 0) select 0, _this select 1, [ARR_3([ARR_2(0, 1)], [ARR_2(0.01, 1)], false)])] call EFUNC(arsenal,statBarStatement_default));
        tabs[]= {{6}, {}};
    };
    class volumeMuffling: statBase {
        scope = 2;
        priority = 1;
        stats[]= {"ACE_hearing_lowerVolume"};
        displayName= CSTRING(statHearingLowerVolume);
        showBar = 1;
        barStatement = QUOTE([ARR_3((_this select 0) select 0, _this select 1, [ARR_3([ARR_2(0, 1)], [ARR_2(0.01, 1)], false)])] call EFUNC(arsenal,statBarStatement_default))
        tabs[]= {{6}, {}};
    };
};