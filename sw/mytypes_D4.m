function T = mytypes_D4(dt)

    F = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap', ...
        'ProductMode', 'FullPrecision', ...
        'SumMode', 'FullPrecision');

    switch(dt)
        case 'single'
            P = fipref;
            P.LoggingMode = 'off';

            T.m = single([]);
            T.m2p0 = single([]);
            T.p = single([]);

        case 'fixed'
            P = fipref;
            P.LoggingMode = 'on';
            dbclear if warning

            T.m = fi([],1,16,14,F);
            T.m2p0 = fi([],1,17,14,F);
            T.p = fi([],1,32,29,F);
    end

end