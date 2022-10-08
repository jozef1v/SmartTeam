
function anomaly_D(id)

% Send fault (anomaly) mail
while(true)
    try
        email2(id);
        break
    catch
        1;
    end
end

end