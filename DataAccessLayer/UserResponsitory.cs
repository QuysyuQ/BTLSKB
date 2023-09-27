﻿using DataAccessLayer.Interface;
using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
	public partial class UserResponsitory : IUserResponsitory
	{
		public IDatabaseHelper _dbHelper;
		public UserResponsitory(IDatabaseHelper databaseHelper)
		{
			_dbHelper = databaseHelper;
		}


		public UserModel Login(string taikhoan, string matkhau)
		{
			string msgError = "";
			try
			{
				var dt = _dbHelper.ExecuteSProcedureReturnDataTable(out msgError, "sp_login",
					 "@taikhoan", taikhoan,
					 "@matkhau", matkhau
					 );
				if (!string.IsNullOrEmpty(msgError))
					throw new Exception(msgError);
				return dt.ConvertTo<UserModel>().FirstOrDefault();
			}
			catch (Exception ex)
			{
				throw ex;
			}
		}
	}
}
