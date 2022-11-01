var express = require("express");
require('dotenv').config();

var app = express();
var server = require("http").createServer(app);

const { Server } = require("socket.io");
const io = new Server(server);

//var io = require("socket.io")(3005);  //process.env.PORT_SOCKETIO


const { Sequelize, DataTypes  } = require('sequelize');


const sequelize = new Sequelize(process.env.DB_DATABASE_NAME, process.env.DB_USERNAME,  process.env.DB_PASSWORD, {
	host: process.env.DB_HOST,
	dialect: 'postgres',
	define: {
        timestamps: false
    },
	logging: false,
	dialectOptions:{
		ssl:{
			require:true,
			rejectUnauthorized:false
		}
	}
  });

 

const sensor = sequelize.define("sensors", {
	temp: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	humi: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	doamdat: {
		type: DataTypes.STRING,
		allowNull: false
	},
	cambienmua: {
		type: DataTypes.STRING,
		allowNull: false
	}
  });

const statusTB = sequelize.define("statusthietbis", {
	ten: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	trangthai: {
		type: DataTypes.STRING,
		allowNull: false
	  }
  });

const hengioTB = sequelize.define("hengiothietbis", {
	ten: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	gioON: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	gioOFF: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	phutON: {
		type: DataTypes.STRING,
		allowNull: false
	  },
	phutOFF: {
		type: DataTypes.STRING,
		allowNull: false
	  }
  });

(async () => {
	try {
		await sequelize.authenticate();
		console.log('Connection has been established successfully.');
	} catch (error) {
		console.error('Unable to connect to the database:', error);
	}
})();

var bandau_results;

io.on('connection', function (socket) {
	console.log("da ket noi !!!");

	//update data sensor len database
	socket.on('updatedataSensor',function (data){
		// var dataupdate = { temp : data.temp, humi: data.humi, doamdat:data.doamdat , cambienmua:data.cambienmua};
		// var query = connection.query('UPDATE sensors SET ? WHERE id = ?',[dataupdate,data.id], function (error, results, fields) {
		// if (error) throw error;
		// });
		// console.log(query.sql);
		(async () => {
			await sensor.update({ temp : data.temp, humi: data.humi, doamdat:data.doamdat , cambienmua:data.cambienmua }, {
				where: {
				id: data.id
				}
			});
		})();
	});

	//update data trang thai thiet bi len database
	socket.on('updatedataStatusTB',function (data){
		// var dataupdate = {trangthai: data.trangthai};
		// var query = connection.query('UPDATE statusthietbis SET ? WHERE id = ?',[dataupdate,data.id], function (error, results, fields) {
		// if (error) throw error;
		// });
		// console.log(query.sql);
		// io.emit('capnhapdataStatusTB',data); 
		// io.emit('capnhapdataStatusTBchoESP8266',data);
		(async () => {
			await statusTB.update({ trangthai: data.trangthai }, {
				where: {
				id: data.id
				}
			});
			io.emit('capnhapdataStatusTB',data); 
			io.emit('capnhapdataStatusTBchoESP8266',data);
		})();
	
	});

	//update hen gio thiet bi On len database
	socket.on('updatedataHenGioOnTB', function (data) {
		// var dataupdate = {gioON: data.gioON, phutON:data.phutON};
		// var query = connection.query('UPDATE hengiothietbis SET ?  WHERE id = ?',[dataupdate, data.id],function (error, results, fields) {
		// 	if (error) throw error;
		// });
		// console.log(query.sql);
		// io.emit('capnhapdataHenGioOnTB',data); 
		// io.emit('capnhapdataHenGioOnTBchoESP8266',data);
		(async () => {
			await hengioTB.update({ gioON: data.gioON, phutON:data.phutON }, {
				where: {
				id: data.id
				}
			});
			io.emit('capnhapdataHenGioOnTB',data); 
			io.emit('capnhapdataHenGioOnTBchoESP8266',data);
		})();
		
	});

	//update hen gio thiet bi Off len database
	socket.on('updatedataHenGioOffTB', function (data) {
		// var dataupdate = {gioOFF: data.gioOFF, phutOFF:data.phutOFF};
		// var query = connection.query('UPDATE hengiothietbis SET ?  WHERE id = ?',[dataupdate, data.id],function (error, results, fields) {
		// 	if (error) throw error;
		// });
		// console.log(query.sql);
		// io.emit('capnhapdataHenGioOffTB',data);
		// io.emit('capnhapdataHenGioOffTBchoESP8266',data); 
		(async () => {
			await hengioTB.update({ gioOFF: data.gioOFF, phutOFF:data.phutOFF }, {
				where: {
				id: data.id
				}
			});
			io.emit('capnhapdataHenGioOffTB',data);
			io.emit('capnhapdataHenGioOffTBchoESP8266',data); 
		})();
	});

	//delete hen gio thiet bi len database
	socket.on('deleteHengio', function (data) {
		// var dataupdate = {gioON:70, phutON:70, gioOFF:70, phutOFF:70};
		// var query = connection.query('UPDATE hengiothietbi SET ?  WHERE id = ?',[dataupdate, data.id],function (error, results, fields) {
		// 	if (error) throw error;
		// });
		// console.log(query.sql);
		// io.emit('capnhapDeleteHengioTB',data); 
		// io.emit('capnhapDeleteHengioTBchoESP8266',data); 
		(async () => {
			await hengioTB.update({ gioON:70, phutON:70, gioOFF:70, phutOFF:70 }, {
				where: {
				id: data.id
				}
			});
			io.emit('capnhapDeleteHengioTB',data); 
			io.emit('capnhapDeleteHengioTBchoESP8266',data); 
		})();
	});

	//dong bo status thiet bi len app android
	socket.on('dongboDataControlTB', function (data) {
		// connection.query('SELECT * FROM statusthietbis', function (error, results, fields) {
		// 	if (error) throw error;	

		// 	if(results != bandau_results)
		// 	{
		// 		bandau_results = results; // neu khac thi gia tri truoc bang gia tri hien tai
		// 		console.log(typeof(results));
		// 		io.emit('dongboallDataStatusTB', results);
		// 	}	
		// });
		(async () => {
			const tbST = await statusTB.findAll({attributes: ['id', 'ten','trangthai'],order:sequelize.col('id')});
			//console.log(tb.every(user => user instanceof statusTB)); // true
			//console.log("All users:",  JSON.parse(JSON.stringify(tbST, null)));
			io.emit('dongboallDataStatusTB', JSON.parse(JSON.stringify(tbST, null)));
		})();
	});

	//dong bo hengio thiet bi len app android
	socket.on('dongboDataHengioTB', function (data) {
		// connection.query('SELECT * FROM hengiothietbi', function (error, results, fields) {
		// 	if (error) throw error;	
		// 	if(results != bandau_results)
		// 	{
		// 		bandau_results = results; // neu khac thi gia tri truoc bang gia tri hien tai
		// 		//console.log(results);
		// 		io.emit('dongboallDataHengioTB', results);	
		// 	}	
		// });	
		(async () => {
			const tbHG = await hengioTB.findAll({attributes: ['id', 'ten','gioON','gioOFF','phutON','phutOFF'],order:sequelize.col('id')});
			//console.log(tb.every(user => user instanceof statusTB)); // true
			//console.log("All users:",  JSON.parse(JSON.stringify(tbHG, null)));
			io.emit('dongboallDataHengioTB', JSON.parse(JSON.stringify(tbHG, null)));
		})();
	});

	//dong bo status thiet bi xuong esp 8266
	socket.on('dongboDataControlTBchoEsp8266', function (data) {
		// connection.query('SELECT * FROM statusthietbi', function (error, results, fields) {
		// 	if (error) throw error;	

		// 	if(results != bandau_results)
		// 	{
		// 		bandau_results = results; // neu khac thi gia tri truoc bang gia tri hien tai
		// 		//console.log(results);
		// 		io.emit('dongboallDataStatusTBchoEsp8266', results);
		// 	}	
		//});
			(async () => {
				const tbSTesp = await statusTB.findAll({attributes: ['id', 'ten','trangthai'],order:sequelize.col('id')});
				//console.log(tb.every(user => user instanceof statusTB)); // true
				//console.log("All users:",  JSON.parse(JSON.stringify(tbSTesp, null)));
				io.emit('dongboallDataStatusTBchoEsp8266', JSON.parse(JSON.stringify(tbSTesp, null)));
			})();
	});

	//dong bo hengio thiet bi xuong esp 8266
	socket.on('dongboDataHengioTBchoEsp8266', function (data) {
		// connection.query('SELECT * FROM hengiothietbi', function (error, results, fields) {
		// 	if (error) throw error;	

		// 	if(results != bandau_results)
		// 	{
		// 		bandau_results = results; // neu khac thi gia tri truoc bang gia tri hien tai
		// 		//console.log(results);
		// 		io.emit('dongboallDataHengioTBchoEsp8266', results);	
		// 	}	
		// });	
		(async () => {
			const tbHGesp = await hengioTB.findAll({attributes: ['id', 'ten','gioON','gioOFF','phutON','phutOFF'],order:sequelize.col('id')});
			//console.log(tb.every(user => user instanceof statusTB)); // true
			//console.log("All users:",  JSON.parse(JSON.stringify(tbHGesp, null)));
			io.emit('dongboallDataHengioTBchoEsp8266', JSON.parse(JSON.stringify(tbHGesp, null)));
		})();
	});

	//update auto Den len database  
	socket.on('updatedataAutoDen',function (data){
		io.emit('capnhapDataAutoDen',data); 
		io.emit('capnhapDataAutoDenchoEsp8266',data);
	});

	//update auto Quat len database  
	socket.on('updatedataAutoQuat',function (data){
		io.emit('capnhapDataAutoQuat',data); 
		io.emit('capnhapDataAutoQuatchoEsp8266',data);
	});

	//update auto Bom len database  
	socket.on('updatedataAutoBom',function (data){
		io.emit('capnhapDataAutoBom',data); 
		io.emit('capnhapDataAutoBomchoEsp8266',data);
	});

	//cap nhap data sensor lay tu database
	capnhapdataSensor();
});



function capnhapdataSensor() {
	setTimeout( function () {

		// connection.query('SELECT * FROM sensors', function (error, results, fields) {
		// 	if (error) throw error;	

		// 	if(results != bandau_results)
		// 	{
		// 		bandau_results = results; // neu khac thi gia tri truoc bang gia tri hien tai
		// 		//console.log(results);
		// 		io.emit('capnhapdataSensor', results);
		// 	}	
		// });	
		(async () => {
			const cambien = await sensor.findAll();
			//console.log(tb.every(user => user instanceof statusTB)); // true
			//console.log("All users:",  JSON.parse(JSON.stringify(cambien, null)));
			io.emit('capnhapdataSensor', JSON.parse(JSON.stringify(cambien, null)));
		})();

		capnhapdataSensor();	
 	},2000);
}	

server.listen(process.env.PORT,function(){
	console.log("Server running port : "+process.env.PORT);
	console.log("socket io port : " + process.env.PORT_SOCKETIO);
});

