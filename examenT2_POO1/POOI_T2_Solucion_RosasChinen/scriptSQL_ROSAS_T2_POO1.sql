USE [master]
GO
/****** Object:  Database [ExaLaboratorio02]    Script Date: 22/06/2024 13:15:00 ******/
CREATE DATABASE [ExaLaboratorio02]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ExaLaboratorio02', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ExaLaboratorio02.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ExaLaboratorio02_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ExaLaboratorio02_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ExaLaboratorio02] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ExaLaboratorio02].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ExaLaboratorio02] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET ARITHABORT OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ExaLaboratorio02] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ExaLaboratorio02] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ExaLaboratorio02] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ExaLaboratorio02] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET RECOVERY FULL 
GO
ALTER DATABASE [ExaLaboratorio02] SET  MULTI_USER 
GO
ALTER DATABASE [ExaLaboratorio02] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ExaLaboratorio02] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ExaLaboratorio02] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ExaLaboratorio02] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ExaLaboratorio02] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ExaLaboratorio02] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ExaLaboratorio02', N'ON'
GO
ALTER DATABASE [ExaLaboratorio02] SET QUERY_STORE = ON
GO
ALTER DATABASE [ExaLaboratorio02] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ExaLaboratorio02]
GO
/****** Object:  Table [dbo].[Venta]    Script Date: 22/06/2024 13:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Venta](
	[IdVenta] [int] NOT NULL,
	[NombreProducto] [varchar](50) NULL,
	[FechaVenta] [date] NULL,
	[Cantidad] [int] NULL,
	[PrecioUnitario] [decimal](18, 4) NULL,
	[SubTotal] [decimal](18, 4) NULL,
	[IGV] [decimal](18, 4) NULL,
	[MontoTotal] [decimal](18, 4) NULL,
 CONSTRAINT [PK_Venta] PRIMARY KEY CLUSTERED 
(
	[IdVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_Venta_Insert]    Script Date: 22/06/2024 13:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Venta_Insert]
(
@NombreProducto VARCHAR(50),
@FechaVenta Date,
@Cantidad int,
@PrecioUnitario decimal (18,4),
@SubTotal decimal(18,4),
@IGV decimal(18,4),
@MontoTotal decimal(18,4),
@exito int output,
@mensaje varchar(200) output
)
AS
BEGIN

	DECLARE @IdVenta int
	
	SET @IdVenta = ISNULL((SELECT MAX(IdVenta) FROM Venta),0) + 1

	INSERT INTO Venta (IdVenta,NombreProducto,FechaVenta,Cantidad,PrecioUnitario,SubTotal,IGV,MontoTotal)
	VALUES (@IdVenta,@NombreProducto,@FechaVenta,@Cantidad,@PrecioUnitario,@SubTotal,@IGV,@MontoTotal)

	set @exito = 1
	set @mensaje = 'Venta registrada con exito. Id: ' + CONVERT(VARCHAR,@IdVenta)

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Venta_List]    Script Date: 22/06/2024 13:15:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Venta_List]
(
@Orden int,
@IdVenta int,
@Buscar varchar(50)
)
AS
BEGIN
	
	IF @Orden = 1 -- lista todo
	BEGIN
		SELECT IdVenta,NombreProducto,FechaVenta,Cantidad,PrecioUnitario,SubTotal,IGV,MontoTotal
		FROM Venta
		WHERE NombreProducto LIKE @Buscar OR FechaVenta LIKE @Buscar
	END

	IF @Orden = 2 --lista por ID
	BEGIN
		SELECT IdVenta,NombreProducto,FechaVenta,Cantidad,PrecioUnitario,SubTotal,IGV,MontoTotal
		FROM Venta
		WHERE IdVenta = @IdVenta
	END

END
GO
USE [master]
GO
ALTER DATABASE [ExaLaboratorio02] SET  READ_WRITE 
GO
