
export function handleError(error) {
    let errorObj = { message : 'Unknown error', status : error.status };

    if (Array.isArray(error.body)) {
        errorObj.message = error.body.map(e => e.message).join(', ');
    } else if (typeof error.body.message === 'string') {
        errorObj.message = error.body.message;
    }

    return errorObj;
}