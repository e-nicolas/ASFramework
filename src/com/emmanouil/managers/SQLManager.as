package com.emmanouil.managers {
	
	import flash.filesystem.File;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.events.SQLErrorEvent;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	
	public class SQLManager {

		//Banco de dados
		private var _path:String;
		private var conn:SQLConnection;
		private var folder:File; 
		private var dbFile:File;
		private var sqlQuery:SQLStatement;
		
		private var embededSessionDB:File;
		private var writeSessionDB:File;
		
		public var onOpenDatabase:Function;
		public var onQueryComplete:Function;
		
		public function SQLManager() {
			// constructor code
		}
		public function openDataBaseWithPath(path:String):void {
			_path = path;
			
			folder = File.applicationStorageDirectory;
			folder.preventBackup = true; //prevent upload to iCloud on Apple Devices
			dbFile = folder.resolvePath(_path);
			
			embededSessionDB = File.applicationDirectory.resolvePath(_path);
			writeSessionDB = File.applicationStorageDirectory.resolvePath(_path);
			
			if (!writeSessionDB.exists) {
				embededSessionDB.copyTo(writeSessionDB);
			}
			
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			conn.openAsync(dbFile, SQLMode.UPDATE);			
		}
		private function openHandler(event: SQLEvent): void {
			trace("[SQL Manager] - Data base opened");
			
			if(onOpenDatabase != null)
				onOpenDatabase("OK");
		}
		public function runQuery(query: String): void {
			sqlQuery = new SQLStatement();
			sqlQuery.sqlConnection = conn;
			sqlQuery.addEventListener(SQLErrorEvent.ERROR, queryError);
			sqlQuery.addEventListener(SQLEvent.RESULT, queryCompleted);					
			sqlQuery.text = query;
			sqlQuery.execute();
		}
		private function errorHandler(event: SQLErrorEvent): void {			
			trace("[SQL Manager] - Error - ", event.error.message);
			trace("Details:", event.error.details);
			
			if(onOpenDatabase != null)
				onOpenDatabase("Error");
		}

		private function queryError(event: SQLErrorEvent) {
			trace("[SQL Manager] - Query Error!");
		}

		private function queryCompleted(event: SQLEvent) {
			const result:SQLResult = event.target.getResult();
			
			if(onQueryComplete != null)
				onQueryComplete(result);			
		}
	}
	
}
