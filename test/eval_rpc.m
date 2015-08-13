function res = eval_rpc(C, lat, lon, alt)
    % one cubic polynomial
    res = C(1) + C(2) .* lon + C(3) .* lat + C(4) .* alt + C(5) .* lon .* lat + C(6) .* lon .* alt + C(7) .* lat .* alt + C(8) .* lon .* lon + C(9) .* lat .* lat + C(10) .* alt .* alt + C(11) .* lat .* lon .* alt + C(12) .* lon .* lon .* lon + C(13) .* lon .* lat .* lat + C(14) .* lon .* alt .* alt + C(15) .* lon .* lon .* lat + C(16) .* lat .* lat .* lat + C(17) .* lat .* alt .* alt + C(18) .* lon .* lon .* alt + C(19) .* lat .* lat .* alt + C(20) .* alt .* alt .* alt;
end

