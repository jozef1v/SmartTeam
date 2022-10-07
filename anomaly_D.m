
function anomaly_D(id)

% Send fault (anomaly) mail
while(true)
    try
        email2(id);
        break
    catch
        errors('email',0);
    end
end

end