function y = intpol2_succ_acc(x, signalLen, interpFactor, interpLen, invU, invU2) %#codegen
    y = zeros(1, interpLen);
    m = 1;

    for n = 1:signalLen-2
        x0 = x(n);
        x1 = x(n+1);
        x2 = x(n+2);

        C0 = x0;

        avg_x2_x0 = (x2 + x0)/2;
        C2 = avg_x2_x0 - x1;
        
        C1 = 2*x1 - x0 - avg_x2_x0;
    
        p1 = C1*invU;
        p2 = C2*invU2; 
    
        d1 = p1;
        d2_main = p2;
        d2_nd = p2;
        p2Gfactorial = 2*p2;
    
        y(m) = C0;
        m = m + 1;
        for cnt1 = 1:interpFactor-1
            d2_nd =  d2_nd + p2Gfactorial;
            y(m) = C0 + d1 + d2_main;
            d2_main = d2_main + d2_nd;
            d1 = p1 + d1;
            m = m + 1;
        end 
    end
end