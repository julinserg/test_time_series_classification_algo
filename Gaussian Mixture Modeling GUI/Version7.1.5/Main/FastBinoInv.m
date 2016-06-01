function z = FastBinoInv(lambda, F)
%Binomial Confidence Intervals
Ns = length(F);

x = zeros(2, Ns );
z = zeros(2, Ns - 2);

if lambda == 0.1,
    xlambda = 1.6405;
    y(1) = 0.05;
    y(2) = 0.95;
elseif lambda == 0.05
    xlambda = 1.96;
    y(1) = 0.025;
    y(2) = 0.975;
else
    xlambda = 2.57;
    y(1) = 0.005;
    y(2) = 0.995;
end

for IndexNs =1:Ns
    if Ns*(1-F(IndexNs))*F(IndexNs) >= 25
        DistLimit = xlambda * sqrt(Ns*F(IndexNs)*(1-F(IndexNs)));
        x(2,IndexNs) = Ns*F(IndexNs) + DistLimit;
        x(1,IndexNs) = Ns*F(IndexNs) - DistLimit;
    else
        if IndexNs == 1
            x(1:2,1) = [0 0];
            cumdist(1) = FastBinoPdf(  x(1,1), Ns, F(1));
            cumdist(2) = FastBinoPdf(  x(2,1), Ns, F(1));
        else
            x(1:2,IndexNs) = x(1:2,IndexNs-1);
            cumdist(1:2) = binocdf(x(1:2,IndexNs-1),Ns,F(IndexNs));
        end

        while cumdist(1) < y(1)
            x(1,IndexNs) = x(1,IndexNs) + 1;
            if x(1,IndexNs) > Ns
                x(1,IndexNs) = Ns;
                cumdist(1) = y(1);
            else
                cumdist(1) = cumdist(1) + ...
                          FastBinoPdf(x(1,IndexNs),Ns, F(IndexNs));
            end
        end

        if x(1,IndexNs) == Ns;
            x(2,IndexNs) = Ns;
            cumdist(2) = y(2);
        end

        % binocdf is inaccurate (becomes 1) for great x, Ns, and F
        if cumdist(2) == 1
            x(2,IndexNs) = Ns*F(IndexNs) + xlambda*...
                                sqrt(Ns*F(IndexNs)*(1-F(IndexNs)));
            if x(2,IndexNs) > Ns
                x(2,IndexNs) = Ns;
            end
        end

        if IndexNs > 1
            if x(2,IndexNs-1) == Ns
                x(2,IndexNs-1) = Ns;
                cumdist(2) = y(2);
            end
        end

        while cumdist(2) < y(2)
            x(2,IndexNs) = x(2,IndexNs) + 1;
            if x(2,IndexNs) > Ns
                x(2,IndexNs)  = Ns;
                cumdist(2) = 1;
            else
                cumdist(2) = cumdist(2) + ...
                          FastBinoPdf(x(2,IndexNs),Ns, F(IndexNs));
            end

            % binocdf becomes 1 for great x, Ns, and F
            if cumdist(2) >= 1
                x(2,IndexNs) = Ns*F(IndexNs) +  ...
                      xlambda * sqrt(Ns*F(IndexNs)*(1-F(IndexNs)));
                if x(2,IndexNs) > Ns
                    x(2,IndexNs) = Ns;
                end
            end
        end
    end   %  >25
end %  IndexNs

z(2,:) = ceil(x(2,2:end-1))/Ns;
z(1,:) = floor(x(1,2:end-1))/Ns;
return

%------------------------------------------------------------------
%-------------------------- FastBinoPdf ---------------------------
%------------------------------------------------------------------
function y = FastBinoPdf(k,N,F)

if F*(1-F)==0 || k*(N-k) ==0,
    if (F==1 && k~=N) || (F==0 && k~=0)
        y= 0;
    elseif (F==1 && k==N) || (F==0 && k==0)
        y = 1;
    elseif k==0
        y = (1-F)^N;
    elseif k==N,
        y = F^N;
    end
else
    if N > 30
        logFN = log(sqrt(2*pi*N)) + N*log(N)-N;
    else
        logFN= log(factorial(N));
    end
   
    if k > 30
        logFk = log(sqrt(2*pi*k)) + k*log(k) - k ;
    else 
        logFk= log(factorial(round(k)));
    end

    if N-k > 30
        logFNmk = log(sqrt(2*pi*(N-k))) + (N-k)*log(N-k) -N+k;
    else
        logFNmk = log(factorial(round(N-k)));
    end
   
    lny=logFN - logFk - logFNmk + k.*log( F) + (N - k).*log(1 - F);
    y = exp(lny);
end
return
