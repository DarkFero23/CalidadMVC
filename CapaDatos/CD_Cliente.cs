using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
    public class CD_Cliente
    {

        public int Registrar(Cliente obj, out string Mensaje)
        {
            int idautogenerado = 0;

            Mensaje = string.Empty;
            try
            {

                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_RegistrarCliente", oconexion);
                    cmd.Parameters.AddWithValue("Nombres", obj.Nombres);
                    cmd.Parameters.AddWithValue("Apellidos", obj.Apellidos);
                    cmd.Parameters.AddWithValue("Correo", obj.Correo);
                    cmd.Parameters.AddWithValue("Clave", obj.Clave);
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                Mensaje = ex.Message;
            }
            return idautogenerado;
        }

        public List<Cliente> Listar()
        {
            List<Cliente> lista = new List<Cliente>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "select IdCliente,Nombres,Apellidos,Correo,Clave from Cliente";
                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                              new Cliente()
                              {
                                  IdCliente = Convert.ToInt32(dr["IdCliente"]),
                                  Nombres = dr["Nombres"].ToString(),
                                  Apellidos = dr["Apellidos"].ToString(),
                                  Correo = dr["Correo"].ToString(),
                                  Clave = dr["Clave"].ToString(),
                              }
                            );
                        }
                    }
                }
            }
            catch
            {
                lista = new List<Cliente>();
            }

            return lista;

        }
        public bool ValidarUsuario(string correo, string clave, out int idCliente)
        {
            idCliente = 0;

            try
            {
                using (SqlConnection connection = new SqlConnection(Conexion.cn))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("ValidarUsuario", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Parámetros de entrada
                        command.Parameters.AddWithValue("@Correo", correo);
                        command.Parameters.AddWithValue("@Clave", clave);

                        // Parámetro de salida
                        SqlParameter idClienteParameter = new SqlParameter("@IdCliente", SqlDbType.Int);
                        idClienteParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(idClienteParameter);

                        command.ExecuteNonQuery();

                        // Asignar el valor del parámetro de salida
                        idCliente = Convert.ToInt32(idClienteParameter.Value);

                        // Si el idCliente es mayor que 0, el usuario es válido
                        return idCliente > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Manejo de errores
                // Puedes registrar el error en un archivo de registro o lanzar una excepción
                // según el flujo de tu aplicación
                Console.WriteLine("Error: " + ex.Message);
                return false;
            }
        }
        public Cliente ObtenerClientePorId(int idCliente)
        {
          
            Cliente cliente = null;

            using (SqlConnection connection = new SqlConnection(Conexion.cn))
            {
                string query = "SELECT * FROM Cliente WHERE IdCliente = @IdCliente";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@IdCliente", idCliente);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();

                if (reader.Read())
                {
                    cliente = new Cliente
                    {
                        IdCliente = Convert.ToInt32(reader["IdCliente"]),
                        Nombres = reader["Nombre"].ToString(),
                        Apellidos = reader["Apellidos"].ToString(),
                        Correo = reader["Correo"].ToString(),
                        Clave = reader["Clave"].ToString(),
                    };
                }

                reader.Close();
            }

            return cliente;
        }

        //    public bool CambiarClave(int idcliente, string nuevaclave, out string Mensaje)
        //    {
        //        bool resultado = false;
        //        Mensaje = string.Empty;
        //        try
        //        {
        //            using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
        //            {
        //                SqlCommand cmd = new SqlCommand("update cliente set clave = @nuevaclave , reestablecer = 0 where idcliente = @id", oconexion);
        //                cmd.Parameters.AddWithValue("@id", idcliente);
        //                cmd.Parameters.AddWithValue("@nuevaclave", nuevaclave);
        //                cmd.CommandType = CommandType.Text;
        //                oconexion.Open();
        //                resultado = cmd.ExecuteNonQuery() > 0 ? true : false;
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            resultado = false;
        //            Mensaje = ex.Message;
        //        }
        //        return resultado;
        //    }



        //    public bool ReestablecerClave(int idcliente, string clave, out string Mensaje)
        //    {
        //        bool resultado = false;
        //        Mensaje = string.Empty;
        //        try
        //        {
        //            using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
        //            {
        //                SqlCommand cmd = new SqlCommand("update cliente set clave = @clave , reestablecer = 1 where idcliente = @id", oconexion);
        //                cmd.Parameters.AddWithValue("@id", idcliente);
        //                cmd.Parameters.AddWithValue("@clave", clave);
        //                cmd.CommandType = CommandType.Text;
        //                oconexion.Open();
        //                resultado = cmd.ExecuteNonQuery() > 0 ? true : false;
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            resultado = false;
        //            Mensaje = ex.Message;
        //        }
        //        return resultado;
        //    }

        //}
    }

}
