function y = intpol2_full(x, signalLen, interpFactor, interpLen, invU, invU2)%#codegen
    y = zeros(1, interpLen);
    m = 1;
    for n = 1:signalLen-2
        % store samples
        x0 = x(n);
        x1 = x(n+1);
        x2 = x(n+2);
    
        % coefficients computation
        C0 = x0;
        C2 = (x2 + x0)/2 - x1;
        C1 =  2*x1 - x0 - (x2 + x0)/2;

        % get first products
        p0 = C1*invU;
        p1 = C2*invU2;
        
        % fist sample Out
        y(m) = x0;
        m = m + 1;
        % Function eval.
        for k = 1:interpFactor-1
            p2 = p0*k;  
            p3 = k*k;
            p4 = p1*p3;
            y(m) = C0 + p2 + p4;
            m = m + 1;
        end  
    end
end