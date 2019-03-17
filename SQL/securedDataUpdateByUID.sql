CREATE OR REPLACE FUNCTION securedDataArrayUpdateByUID(user_id VARCHAR, curr_data_id VARCHAR, p_value VARCHAR) 
RETURNS VOID as $$

DECLARE 

 cur_priority INT;
 to_modify VARCHAR[20];

 
BEGIN

cur_priority = getPriority(user_id, curr_data_id, 'update_p');
	
	CASE cur_priority
		WHEN 1 OR 3 THEN
			SELECT security_groups INTO to_modify FROM data WHERE data_id = curr_data_id ;
            UPDATE data SET security_groups = array_append(to_modify, p_value) WHERE data_id = curr_data_id;
		WHEN 2 THEN
			RAISE EXCEPTION 'Forbidden';
		WHEN 4 THEN
			RAISE EXCEPTION 'None';
		WHEN 5 THEN
			RAISE EXCEPTION 'Undefined';
		WHEN 6 THEN
			RAISE EXCEPTION 'Unrelated';
	
	END CASE;
END; $$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION securedDataJsonUpdateByUID(user_id VARCHAR, curr_data_id VARCHAR, p_value VARCHAR[], p_path VARCHAR[]) 
RETURNS VOID as $$

DECLARE 

 cur_priority INT;
 dataset jsonb;
 current_node VARCHAR;

 
BEGIN

cur_priority = getPriority(user_id, curr_data_id, 'update_p');
	
	CASE cur_priority
		WHEN 1 OR 3 THEN
			
            SELECT datas INTO dataset FROM data WHERE data_id = curr_data_id;
            IF array_length(p_path, 0) > 1 THEN
                FOREACH current_node in ARRAY p_path
                LOOP
                    
                END LOOP;
            ELSE
                    UPDATE data SET datas = jsonb_set(datas, '{' + p_path + '}', p_value::jsonb);
            END IF;
            

		WHEN 2 THEN
			RAISE EXCEPTION 'Forbidden';
		WHEN 4 THEN
			RAISE EXCEPTION 'None';
		WHEN 5 THEN
			RAISE EXCEPTION 'Undefined';
		WHEN 6 THEN
			RAISE EXCEPTION 'Unrelated';
	
	END CASE;
END; $$

LANGUAGE 'plpgsql';