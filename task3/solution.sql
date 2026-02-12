DROP VIEW IF EXISTS v_users_activity;

CREATE VIEW v_users_activity AS
WITH server_logs_with_duration AS (
    SELECT 
        *,
        ROUND((julianday(Session_End) - julianday(Session_Start)) * 24 * 60, 2) AS Session_Dur
    FROM server_logs
)
SELECT 
    u.id AS User_ID,
    u.first_name AS First_Name,
    u.last_name AS Last_Name,
    COUNT(sl.User_ID) AS Num_Sessions,
    COALESCE(SUM(sl.Session_Dur), 0) AS Total_Session_Time
FROM users u
LEFT JOIN server_logs_with_duration sl ON u.id = sl.User_ID
GROUP BY u.id, u.first_name, u.last_name
ORDER BY Total_Session_Time DESC;