const aws = require('aws-sdk');
const lambda = new aws.Lambda();

const loadToEnv = (secretName) => {
    if (global.envLoaded) {
        console.log("env loaded already");
        return ;
    }

    var params = {
        FunctionName: 'SecretsHelper', // the lambda function we are going to invoke
        InvocationType: 'RequestResponse',
        LogType: 'Tail',
        Payload: JSON.stringify({secretName})
    };
    return new Promise((resolve, reject) => {
        // Nota: lambda.invoke no retorna nada en el error, a menos que sea un 500
        // SecretsHelper retorna {statusCode: 400} si encuentra un error
        lambda.invoke(params, (_err, res) => {
            console.log(_err, res)
            const data = JSON.parse(res.Payload); // lambda payload is string
            if (data.statusCode === 400) {
                console.error(data);
                reject(new Error("Error llamando SecretsHelper:\n" + res.Payload));
            } else {
                process.env = Object.assign(process.env, data.body);
                global.envLoaded = true;
                resolve();
            }
        });
    });
}

module.exports = {
    loadToEnv
}