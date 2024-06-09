Few Steps to follow - 
1. Set up your Snowflake and AWS account.
2. Create your AWS S3 Bucket with required access through right IAM policies. 
3. Then create a External volume in Snowflake after assigning the S3 url and the Role ARN from Step #2. Also remember that you should define an External Id - The example specifies the external ID (iceberg_table_external_id) associated with the IAM role that you created for the external volume. Specifying an external ID lets you use the same IAM role (and external ID) across multiple external volumes.
4. Then grant IAM user permission after updating the IAM role previously created after updating the created External Id created in Step #3.

Link to follow - https://docs.snowflake.com/en/user-guide/tables-iceberg-configure-external-volume-s3

5. Once the external volume have been created now to test it you should create an iceberg table.
Link to follow - https://docs.snowflake.com/en/user-guide/tables-iceberg-create

6. For performance exteriment - I have cretaed 2 iceberg tables based on the Snowflake sample data (Customer and Customer Address) and finally created another iceberg table joining those 2 tables.

7. Finally compared 2 sets of operations on iceberge tables and normal Snowflake tables.
