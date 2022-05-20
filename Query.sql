USE Logi
--Join all tables 
SELECT 
	dbo.Order_list_csv.*,
	dbo.HubVN_csv.HubVN_ID,
	dbo.HubVN_csv.HubVN_Pickup_Time,
	dbo.HubVN_csv.HubVN_Receiving_Time,
	dbo.HubVN_csv.Plan_HubVN_Pickup_Time,
	dbo.HubVN_csv.Plan_HubVN_Receiving_Time,
	dbo.HubCN_csv.HubCN_ID,
	dbo.HubCN_csv.HubCN_Pickup_Time,
	dbo.HubCN_csv.HubCN_Receiving_Time,
	dbo.HubCN_csv.Plan_HubCN_Pickup_Time,
	dbo.HubCN_csv.Plan_HubCN_Receiving_Time,
	dbo.Vendor_map_csv.Pickup_Address,
	dbo.Vendor_map_csv.Plan_Vendor_Pickup_Time,
	dbo.Vendor_map_csv.Vendor_ID,
	dbo.Vendor_map_csv.Vendor_PickupTime,
	DATEDIFF(DAY,  Order_list_csv.Order_Create_Time, Order_list_csv.Enduser_Deliverytime) RealLeadTime,
	DATEDIFF(DAY, Order_list_csv.Order_Create_Time, Order_list_csv.Enduser_Plan_Deliverytime) PlanLeadTime,
	CASE
		WHEN DATEDIFF(DAY,  Order_list_csv.Order_Create_Time, Order_list_csv.Enduser_Deliverytime) - DATEDIFF(DAY, Order_list_csv.Order_Create_Time, Order_list_csv.Enduser_Plan_Deliverytime) < 0 THEN 0
		ELSE DATEDIFF(DAY,  Order_list_csv.Order_Create_Time, Order_list_csv.Enduser_Deliverytime) - DATEDIFF(DAY, Order_list_csv.Order_Create_Time, Order_list_csv.Enduser_Plan_Deliverytime)
	END Delay_Lead_Time,
	CASE
		WHEN DATEDIFF(DAY, dbo.Vendor_map_csv.Plan_Vendor_Pickup_Time, dbo.Vendor_map_csv.Vendor_PickupTime) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.Vendor_map_csv.Plan_Vendor_Pickup_Time, dbo.Vendor_map_csv.Vendor_PickupTime)
	END Supplier_delay_pickup_time,
	CASE
		WHEN DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Pickup_Time, dbo.HubVN_csv.HubVN_Pickup_Time) < 0 THEN 0 
		ELSE DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Pickup_Time, dbo.HubVN_csv.HubVN_Pickup_Time) 
	END HubVN_Delay_pickup_time,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Receiving_Time, dbo.HubVN_csv.HubVN_Receiving_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Receiving_Time, dbo.HubVN_csv.HubVN_Receiving_Time) 
	END HubVN_Delay_Receiving_time,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Receiving_Time, dbo.HubCN_csv.HubCN_Receiving_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Receiving_Time, dbo.HubCN_csv.HubCN_Receiving_Time)
	END HubCN_Delay_Receiving_time,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Pickup_Time, dbo.HubCN_csv.HubCN_Pickup_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Pickup_Time, dbo.HubCN_csv.HubCN_Pickup_Time)
	END HubCN_Delay_Pickup_time,
	CASE 
		WHEN DATEDIFF(DAY, dbo.Vendor_map_csv.Plan_Vendor_Pickup_Time, dbo.HubCN_csv.Plan_HubCN_Receiving_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.Vendor_map_csv.Plan_Vendor_Pickup_Time, dbo.HubCN_csv.Plan_HubCN_Receiving_Time)
	END Vendor_to_HubCN_PlanDeliveryTime,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Pickup_Time, dbo.HubVN_csv.Plan_HubVN_Receiving_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Pickup_Time, dbo.HubVN_csv.Plan_HubVN_Receiving_Time)
	END HubCN_to_HubVN_PlanDeliveryTime,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Pickup_Time, dbo.Order_list_csv.Enduser_Plan_Deliverytime) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Pickup_Time, dbo.Order_list_csv.Enduser_Plan_Deliverytime)
	END HubVN_to_Customers_PlanDeliveryTime,
		CASE 
		WHEN DATEDIFF(DAY, dbo.Vendor_map_csv.Vendor_PickupTime, dbo.HubCN_csv.HubCN_Receiving_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.Vendor_map_csv.Vendor_PickupTime, dbo.HubCN_csv.HubCN_Receiving_Time)
	END Vendor_to_HubCN_DeliveryTime,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubCN_csv.HubCN_Pickup_Time, dbo.HubVN_csv.HubVN_Receiving_Time) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubCN_csv.HubCN_Pickup_Time, dbo.HubVN_csv.HubVN_Receiving_Time)
	END HubCN_to_HubVN_DeliveryTime,
	CASE 
		WHEN DATEDIFF(DAY, dbo.HubVN_csv.HubVN_Pickup_Time, dbo.Order_list_csv.Enduser_Deliverytime) < 0 THEN 0
		ELSE DATEDIFF(DAY, dbo.HubVN_csv.HubVN_Pickup_Time, dbo.Order_list_csv.Enduser_Deliverytime)
	END HubVN_to_Customers_DeliveryTime,
	DATEDIFF(DAY, dbo.HubCN_csv.Plan_HubCN_Receiving_Time, dbo.HubCN_csv.Plan_HubCN_Pickup_Time) Plan_Processing_time_HubCN,
	DATEDIFF(DAY, dbo.HubVN_csv.Plan_HubVN_Receiving_Time, dbo.HubVN_csv.Plan_HubVN_Pickup_Time) Plan_Processing_time_HubVN,
	DATEDIFF(DAY, dbo.HubCN_csv.HubCN_Receiving_Time, dbo.HubCN_csv.HubCN_Pickup_Time) Processing_time_HubCN,
	DATEDIFF(DAY, dbo.HubVN_csv.HubVN_Receiving_Time, dbo.HubVN_csv.HubVN_Pickup_Time) Processing_time_HubVN,
	CASE 
		WHEN Order_list_csv.Grossweight <= 2 AND dbo.Order_list_csv.Carrier = 'Inhouse'  THEN 11000
		WHEN Order_list_csv.Grossweight > 2 AND Order_list_csv.Grossweight <= 4 AND dbo.Order_list_csv.Carrier = 'Inhouse' THEN 17500
		WHEN Order_list_csv.Grossweight > 4 AND dbo.Order_list_csv.Carrier = 'Inhouse' THEN 17500 +  6000*FLOOR((Order_list_csv.Grossweight-4))
		WHEN Order_list_csv.Grossweight < 3.5 AND RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) LIKE 'Q%' AND dbo.Order_list_csv.Carrier = 'LogExpress' THEN 20000
		WHEN Order_list_csv.Grossweight < 3.5 AND RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) LIKE 'H%' AND dbo.Order_list_csv.Carrier = 'LogExpress' THEN 25000
		WHEN Order_list_csv.Grossweight < 3.5 AND RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) LIKE 'T%' AND dbo.Order_list_csv.Carrier = 'LogExpress' THEN 25000
		WHEN Order_list_csv.Grossweight >= 3.5 AND RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) LIKE 'Q%' AND dbo.Order_list_csv.Carrier = 'LogExpress' THEN 20000 + 2500*FLOOR((Order_list_csv.Grossweight-3)/0.5)
		WHEN Order_list_csv.Grossweight >= 3.5 AND RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) LIKE 'H%' AND dbo.Order_list_csv.Carrier = 'LogExpress' THEN 25000 + 2500*FLOOR((Order_list_csv.Grossweight-3)/0.5)
		WHEN Order_list_csv.Grossweight >= 3.5 AND RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) LIKE 'T%' AND dbo.Order_list_csv.Carrier = 'LogExpress' THEN 25000 + 2500*FLOOR((Order_list_csv.Grossweight-3)/0.5)
		WHEN Order_list_csv.Grossweight <= 0.1 AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 8000
		WHEN Order_list_csv.Grossweight > 0.1 AND Order_list_csv.Grossweight <= 0.25  AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 10000
		WHEN Order_list_csv.Grossweight > 0.25 AND Order_list_csv.Grossweight <= 0.5  AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 12500
		WHEN Order_list_csv.Grossweight > 0.5 AND Order_list_csv.Grossweight <= 1  AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 16000
		WHEN Order_list_csv.Grossweight > 1 AND Order_list_csv.Grossweight <= 1.5  AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 19000
		WHEN Order_list_csv.Grossweight > 1.5 AND Order_list_csv.Grossweight <= 2  AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 21000
		WHEN Order_list_csv.Grossweight > 2  AND dbo.Order_list_csv.Carrier = 'ECLogistics' THEN 21000 + 1700*FLOOR((dbo.Order_list_csv.Grossweight - 2)/0.5)
		ELSE NULL
	END Last_Mile_Transport_cost,
	RIGHT(dbo.Order_list_csv."Address", CHARINDEX(',', CAST (REVERSE(dbo.Order_list_csv."Address") AS varchar)) - 2) District,
	CASE
		WHEN dbo.HubCN_csv.HubCN_ID = 'LECCNYW' THEN dbo.Order_list_csv.Quantity_piece * 700
		WHEN dbo.HubCN_csv.HubCN_ID = 'LECCNSZ' THEN dbo.Order_list_csv.Quantity_piece * 500
		ELSE NULL
	END Procession_Cost_CN,
	CASE 
		WHEN dbo.HubCN_csv.HubCN_ID = 'LECCNYW' AND dbo.Order_list_csv.Grossweight <= 3 THEN 15000
		WHEN dbo.HubCN_csv.HubCN_ID = 'LECCNYW' AND dbo.Order_list_csv.Grossweight > 3 THEN 15000 + 2500*FLOOR((dbo.Order_list_csv.Grossweight - 3))
		WHEN dbo.HubCN_csv.HubCN_ID = 'LECCNSZ' AND dbo.Order_list_csv.Grossweight <= 3 THEN 17000
		WHEN dbo.HubCN_csv.HubCN_ID = 'LECCNSZ' AND dbo.Order_list_csv.Grossweight > 3 THEN 17000 + 1500*FLOOR((dbo.Order_list_csv.Grossweight - 3))
		ELSE NULL
	END CN_Transport_cost into #tempt_table
FROM dbo.Order_list_csv 
LEFT JOIN dbo.HubCN_csv ON HubCN_csv.Order_ID = dbo.Order_list_csv.Order_ID
LEFT JOIN dbo.HubVN_csv ON HubVN_csv.Order_ID = Order_list_csv.Order_ID
LEFT JOIN dbo.Vendor_map_csv ON Vendor_map_csv.Order_ID = Order_list_csv.Order_ID

SELECT *, Last_Mile_Transport_cost + Procession_Cost_CN + CN_Transport_cost Total_cost FROM #tempt_table