CREATE OR REPLACE FUNCTION add_loyalty_card()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Loyalty_Card WHERE UserId = NEW.UserId) THEN
        IF (SELECT COUNT(*) 
            FROM Orders 
            WHERE UserId = NEW.UserId 
            AND Order_Date >= CURRENT_DATE - INTERVAL '1 year') > 15
        AND (SELECT SUM(Total_Amount) 
             FROM Orders 
             WHERE UserId = NEW.UserId 
             AND Order_Date  >= CURRENT_DATE - INTERVAL '1 year') > 1000 THEN
            
            INSERT INTO Loyalty_Card (UserId, Issue_date)
            VALUES (NEW.UserId, CURRENT_DATE);
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_loyalty_card
AFTER INSERT ON Orders
FOR EACH ROW
EXECUTE FUNCTION add_loyalty_card();
--DROP TRIGGER trigger_loyalty_card ON Orders;

