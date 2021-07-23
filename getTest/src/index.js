const secrets = require('secrets');

exports.handler = async (event) => {
    // secrets
    try {
        await secrets.loadToEnv(process.env.SECRET_NAME);
    } catch(e) {
        throw e;
    }
    
    const response = {
        statusCode: 200,
        body: process.env,
    };
    return response;
};
