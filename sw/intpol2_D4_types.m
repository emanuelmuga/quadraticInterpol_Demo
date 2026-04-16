function y = intpol2_D4_types(x, invX, invX2, interpFactor, signalLen, interpLen, DT) %#codegen

    m0 = zeros(1, 'like', DT.m);
    m1 = zeros(1, 'like', DT.m);
    m2 = zeros(1, 'like', DT.m);
    C0 = zeros(1, 'like', DT.m);
    C1 = zeros(1, 'like', DT.m);
    C2 = zeros(1, 'like', DT.m);
    m2_plus_m0 = zeros(1, 'like', DT.m2p0);
    m2_plus_m0_div2 = zeros(1, 'like', DT.m);
    twoTimes_m1 = zeros(1, 'like', DT.m2p0);
    p1 = zeros(1, 'like', DT.p);
    p2 = zeros(1, 'like', DT.p);
    xi = zeros(1, 'like', DT.p);
    xi2_main = zeros(1, 'like', DT.p);
    xi2_nd = zeros(1, 'like', DT.p);
    p2Gfactorial = zeros(1, 'like', DT.p);
    invX_c = cast(invX, 'like', DT.p);
    invX2_c = cast(invX2, 'like', DT.p);


    y = zeros(1, interpLen, 'like', DT.m);

    idx = 1;

    for cnt0 = 1:signalLen-2
        m0(:) = x(cnt0);
        m1(:) = x(cnt0+1);
        m2(:) = x(cnt0+2);

        C0(:) = m0;

        m2_plus_m0(:) = (m2 + m0);
        m2_plus_m0_div2(:) = m2_plus_m0/2;
        C2(:) = (m2_plus_m0_div2 - m1);

        twoTimes_m1(:) = 2*m1;
        C1(:) = (twoTimes_m1 - m0 - m2_plus_m0_div2);

        p1(:) = C1*invX_c;
        p2(:) = C2*invX2_c;

        xi(:) = p1;
        xi2_main(:) = p2;
        xi2_nd(:) = p2;
        p2Gfactorial(:) = 2*p2;

        y(idx) = C0;
        for cnt1 = 1:interpFactor-1
            xi2_nd(:) =  xi2_nd + p2Gfactorial;
            y(idx+1) = C0 + xi + xi2_main;
            xi2_main(:) = xi2_main + xi2_nd;
            xi(:) = p1 + xi;
            idx = idx + 1;
        end 
        idx = idx + 1;
    end

end