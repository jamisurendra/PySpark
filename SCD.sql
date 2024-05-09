-- Create the SCD 2 table
CREATE TABLE scd2_table (
    id INT PRIMARY KEY,
    attribute1 VARCHAR(50),
    attribute2 VARCHAR(50),
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN
);

-- Insert or update the data in the SCD 2 table
INSERT INTO scd2_table (id, attribute1, attribute2, start_date, end_date, is_current)
SELECT 
    source.id,
    source.attribute1,
    source.attribute2,
    source.start_date,
    source.end_date,
    CASE
        WHEN scd_table.end_date IS NULL THEN true
        ELSE false
    END
FROM source_table AS source
LEFT JOIN scd2_table AS scd_table
    ON source.id = scd_table.id
WHERE 
    source.start_date >= scd_table.start_date OR scd_table.start_date IS NULL;

-- Set the end_date of the previous version of the updated rows
UPDATE scd2_table AS t
SET end_date = (SELECT MIN(start_date) - INTERVAL 1 DAY
                FROM
