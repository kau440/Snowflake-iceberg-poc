/*Steps following for External Volumn creation
https://docs.snowflake.com/en/user-guide/tables-iceberg-configure-external-volume-s3
 */

CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'kb-s3-ap-southeast-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = '<bucket-name>'
            STORAGE_AWS_ROLE_ARN = '<role-arn>'
            STORAGE_AWS_EXTERNAL_ID = 'iceberg_table_external_id'
         )
      );



      DESC EXTERNAL VOLUME iceberg_external_volume;

/*Note: 
      IAM User for Snowflake - 
        IAM Role for Snowflake - 
    Snowflake provisions a single IAM user for your entire Snowflake account. All S3 external volumes in your account use that IAM user.
    
    STORAGE_AWS_EXTERNAL_ID = 'iceberg_table_external_id'
    If you didn’t specify an external ID (STORAGE_AWS_EXTERNAL_ID) when you created an external volume, Snowflake generates an ID for you to use. Record the value so that you can update your IAM role trust policy with the generated external ID.
 */

 /* Step #6 - AWS
Grant the IAM user permissions to access bucket objects. From the AWS Management Console, navigate to the bucket that you specified in the STORAGE_BASE_URL parameter. Grant the IAM user the necessary permissions to access the bucket objects. For example, you can grant the IAM user the AmazonS3ReadOnlyAccess policy.

Note: To verify that your permissions are configured correctly, create an Iceberg table using this external volume. Snowflake doesn’t verify that your permissions are set correctly until you create an Iceberg table that references this external volume.
 
  */

/* Step #7 - Test the External Volume after creating a iceberg table */
use database RAW;
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table (
    boolean_col boolean,
    int_col int,
    long_col long,
    float_col float,
    double_col double,
    decimal_col decimal(10,5),
    string_col string,
    fixed_col fixed(10),
    binary_col binary,
    date_col date,
    time_col time,
    timestamp_ntz_col timestamp_ntz(6),
    timestamp_ltz_col timestamp_ltz(6)
  )
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'experiment/extvol';

/* Creating few sample tables */
  create or replace iceberg table sample_CATALOG_RETURNS
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'experiment/extvol'
AS 
  select * from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CATALOG_RETURNS limit 1000;



  create or replace iceberg table sample_CUSTOMER
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'experiment/extvol'
AS 
  select * from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER;

  create or replace iceberg table sample_CUSTOMER_ADDRESS
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'experiment/extvol'
AS 
  select * from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER_ADDRESS;


SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER

  select * from sample_CATALOG_RETURNS limit 100;
  --truncate table sample_CATALOG_RETURNS;

/* Performance experiment */
create or replace iceberg table sample_Cust_wth_Address
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'experiment/extvol'
AS  
select C.*,A.CA_ADDRESS_ID,A.CA_GMT_OFFSET,A.CA_LOCATION_TYPE from RAW.PUBLIC.SAMPLE_CUSTOMER C
    left join RAW.PUBLIC.SAMPLE_CUSTOMER_ADDRESS A 
    On C.C_CURRENT_ADDR_SK=A.CA_ADDRESS_SK;


create table SF_sample_Cust_wth_Address as
select C.*,A.CA_ADDRESS_ID,A.CA_GMT_OFFSET,A.CA_LOCATION_TYPE from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER C
    left join SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER_ADDRESS A 
    On C.C_CURRENT_ADDR_SK=A.CA_ADDRESS_SK;



select count(*) from sample_Cust_wth_Address;

select count(*) from SF_sample_Cust_wth_Address;  ---- 100,000,000