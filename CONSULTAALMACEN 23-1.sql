

DECLARE @PageNumber INT = 1;
DECLARE @RowsPerPage INT = 100



SELECT DISTINCT

Movimientos.Programa AS 'transaction'
,Movimientos.AAAA AS 'year'
,Movimientos.Clase AS 'document_type'
,Movimientos.Des_Doc 'document_name'
,Movimientos.Status 'status'
,DescripcionStatus.Descripcion AS 'status_desc'
,Movimientos.Desc_General AS 'requester'
,Movimientos.Observaciones AS 'observations'
,Movimientos.Entregado AS 'delivered_by'
,Movimientos.Fec_Crt AS 'creation_date'
,Movimientos.Doc_Hora AS 'creation_time'
,Movimientos.Usr_CRT AS 'user_creation'
,Movimientos.Doc_Emitido AS 'document_number'
,Movimientos.Doc01_Fecha AS 'document_date'
, STRING_AGG(
            '(code:' + Movimientos.Producto + 
               ', name: "'+
               CAST(Movimientos.Des_Prod AS NVARCHAR(MAX)) + 
               '", quantity: ' +
               CAST(cast(Movimientos.Cantidad AS INT) AS NVARCHAR(MAX)) + 
               '", unit: ' +
               CAST(Movimientos.Medida AS NVARCHAR(MAX)) + ')'
               , ', ') 
AS 'products'
      
 FROM iERP_AQMR_PR.dbo.In_DetMov AS Movimientos 
    JOIN
    	iERP_AQMR_PR.dbo.In_Tablas_Add AS DescripcionStatus ON (Movimientos.Status = DescripcionStatus.Codigo AND DescripcionStatus.Tipo = 12)
    


GROUP BY Movimientos.Programa, Movimientos.AAAA, Movimientos.Clase, Movimientos.Des_Doc, Movimientos.Status, DescripcionStatus.Descripcion, Movimientos.Desc_General, Movimientos.Observaciones, Movimientos.Entregado, Movimientos.Fec_Crt, Movimientos.Doc_Hora, Movimientos.Usr_CRT, Movimientos.Doc_Emitido, Movimientos.Doc01_Fecha
ORDER BY Doc01_Fecha DESC, Doc_Hora DESC
OFFSET (@PageNumber - 1) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY;
