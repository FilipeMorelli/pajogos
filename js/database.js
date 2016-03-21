var DataBase;
(function (window, document, navigator, myApp) {
    var db;
    var name = "ZikaGame";
    var maxSize = 65536;
    var version = "1.0";
    var displayName = "ZikaGame";

    DataBase = {
        lastResultQuery: null,
        open: function () {
            db = openDatabase(name, version, displayName, maxSize);
            //criação de todas as tabelas necessárias
        },
        sqlExecute: function (query, parameters = null) {
            db.transaction(function (transaction) {
                transaction.executeSql(query, parameters, function (transaction, result) {
                    DataBase.lastResultQuery = result;
                    //console.log(result);
                }, function (transaction, error) {
                    myApp.alert(error.message, "Error: "+error.code);
                    //insert de erros
                    console.log(error);
                })
            });
        }
    }

})(window, document, navigator, myApp)