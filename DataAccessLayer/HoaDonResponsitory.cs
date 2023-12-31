﻿using DataAccessLayer.Interface;
using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
	public partial class HoaDonResponsitory : IHoaDonResponsitory
	{
		private IDatabaseHelper _dbHelper;
		public HoaDonResponsitory(IDatabaseHelper dbHelper)
		{
			_dbHelper = dbHelper;
		}

		public List<HoaDonModel> GetallHoaDon()
		{
			string msgError = "";
			try
			{
				var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_get_all_hoadon");
				if (!string.IsNullOrEmpty(msgError))
					throw new Exception(msgError);
				return dt.ConvertTo<HoaDonModel>().ToList();
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}

		public bool Create(HoaDonModel model)
		{
			string msgError = "";
			try
			{
				var xxx = model.list_json_chitietHDN != null ? MessageConvert.SerializeObject(model.list_json_chitietHDN) : null;
				var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_create_hoadonnhap",
				"@InvoiceID", model.InvoiceID,
				"@InvoiceDate", model.InvoiceDate,
				"@SupplierID", model.SupplierID,
				"@list_json_chitiethoadon", model.list_json_chitietHDN != null ? MessageConvert.SerializeObject(model.list_json_chitietHDN) : null);
				if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
				{
					throw new Exception(Convert.ToString(result) + msgError);
				}
				return true;
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}

			public bool Update(HoaDonModel model)
			{
			string msgError = "";
			try
			{

				var result = _dbHelper.ExecuteScalarSProcedureWithTransaction(out msgError, "sp_hoadon_update",
				"@InvoiceID", model.InvoiceID,
				"@InvoiceDate", model.InvoiceDate,
				"@SupplierID", model.SupplierID);
				if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
				{
					throw new Exception(Convert.ToString(result) + msgError);
				}
				return true;
			}

			catch (Exception ex)
			{
				throw ex;
			}
		}

		public bool Delete(int id)
		{
			string msgError = "";
			try
			{
				string result = "";
				var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_delele_HoaDonNhap",
					"@InvoiceID", id);
				if ((result != null && !string.IsNullOrEmpty(result.ToString())) || !string.IsNullOrEmpty(msgError))
				{
					throw new Exception(Convert.ToString(result) + msgError);
				}
				return true;
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}

		public HoaDonModel Create(int id)
		{
			throw new NotImplementedException();
		}
	}
}