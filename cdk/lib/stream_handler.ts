import lambda = require('@aws-cdk/aws-lambda')
import iam = require('@aws-cdk/aws-iam')
import { BachStack } from './bach-stack';
import uuid = require('uuid')

export interface IStreamHandler {
    addEventSource(eventSource: lambda.IEventSource): void;
}

export abstract class LambdaRuntime {
    protected _id: string = 'H' + uuid();
    protected _resource: lambda.Function;
    protected _stack: BachStack;

    constructor(stack: BachStack) {
        this._stack = stack;
    }
}

export interface LambdaHandlerProps {
    handlerName: string;
    _role: iam.IRole;

}

export abstract class NodeJSLambdaRuntime extends LambdaRuntime {
    protected _runTime: lambda.Runtime = lambda.Runtime.NODEJS_10_X; 
}

export abstract class NodeJsLambdaStreamHandler extends NodeJSLambdaRuntime implements IStreamHandler {
    constructor(stack: BachStack, props: lambda.FunctionProps) {
        super(stack);
        this._resource = new lambda.Function(this._stack, this._id, props);
    }

    addEventSource(eventSource: lambda.IEventSource): void {
        this._resource.addEventSource(eventSource);
    }
}

export class NodeJsLambdaKinesisStreamHandler extends NodeJsLambdaStreamHandler {
    constructor(stack: BachStack, props: lambda.FunctionProps) {
        super(stack, props);
    }

}

export interface IStreamHandlerFactory {
    createHandler(): IStreamHandler;
    setEnvironment(env: { [key: string]: string; }): void;
}

export class NodeJsLambdaKinesisStreamHandlerFactory implements IStreamHandlerFactory {
    protected _runTime: lambda.Runtime = lambda.Runtime.NODEJS_10_X; 
    _handlerName: string = 'kinesis_handler.handler';
    _codePath: string = 'dist';
    _props: lambda.FunctionProps;
    _role: iam.IRole;
    _stack: BachStack;
    _env: { [key: string]: string; };

    constructor(stack: BachStack) {
        this._stack = stack;
        //TODO
        this._role = iam.Role.fromRoleArn(stack, 'ExcutionRole', '');
    }
    
    createHandler(): IStreamHandler {
        this.initProps();
        return new NodeJsLambdaKinesisStreamHandler(this._stack, this._props);
    }

    initProps(): void{
        this._props = {
            runtime: this._runTime,
            code: new lambda.AssetCode(this._codePath),
            role: this._role,
            handler: this._handlerName,
            environment: this._env
        };
    }

    setEnvironment(env: { [key: string]: string; }): void {
        this._env = env;
    }
}