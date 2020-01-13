import kinesis = require('@aws-cdk/aws-kinesis')
import dynamodb = require('@aws-cdk/aws-dynamodb')
import iam = require('@aws-cdk/aws-iam')
import lambda = require('@aws-cdk/aws-lambda')
import { IStreamHandler, IStreamHandlerFactory, NodeJsLambdaKinesisStreamHandlerFactory } from './stream_handler'
import { BachStack } from './bach-stack';
import { KinesisEventSource, DynamoEventSource } from '@aws-cdk/aws-lambda-event-sources'
import uuid = require('uuid')

export interface IStream<I> {
    listen<T>(stream: IStream<T>): void;
    
    put(record: I): void;

    eventSource(): lambda.IEventSource;

    handlerFactory(): IStreamHandlerFactory;
};


/**
 * 
 */
export class KinesisStream<I> implements IStream<I> {
    private static DefaultProps: kinesis.StreamProps = {
        shardCount: 2,
        retentionPeriodHours: 48
    };
    private _id: string = 'K' + uuid();
    private _resource: kinesis.Stream;
    private _props: kinesis.StreamProps;
    private _stack: BachStack;

    constructor(stack: BachStack, props?: kinesis.StreamProps) {
        this._stack = stack;
        if (props) {
            this._props = props;
        } else {
            this._props = KinesisStream.DefaultProps;
        }
        this._resource = new kinesis.Stream(this._stack, this._id, this._props)
    }

    get resource(): kinesis.Stream {
        return this._resource;
    }

    get props(): kinesis.StreamProps {
        return this._props;
    }

    listen<T>(stream: IStream<T>): void {
    }
    
    put(record: I): void {

    }

    eventSource(): lambda.IEventSource {
        console.log("new event source")
        return new KinesisEventSource(this._resource, {
            batchSize: 100,
            startingPosition: lambda.StartingPosition.TRIM_HORIZON
          });
    }

    handlerFactory(): IStreamHandlerFactory {
        return new NodeJsLambdaKinesisStreamHandlerFactory(this._stack);
    }
}

export class DynamoDBStream<I> implements IStream<I> {
    private static DefaultProps: dynamodb.TableProps = {
        partitionKey: {
          name: 'hash_key',
          type: dynamodb.AttributeType.STRING
        }
    };

    private _id: string = 'D' + uuid();
    private _stack: BachStack
    private _resource: dynamodb.Table;
    private _props: dynamodb.TableProps;

    constructor(stack: BachStack, props?: dynamodb.TableProps) {
        this._stack = stack;
        if (props) {
            this._props = props;
        } else {
            this._props = DynamoDBStream.DefaultProps;
        }
        this._resource = new dynamodb.Table(this._stack, this._id, this._props);
    }

    get resource(): dynamodb.Table {
        return this._resource;
    }

    get props(): dynamodb.TableProps {
        return this._props;
    }

    listen<T>(stream: IStream<T>): void {
        let handlerFactory: IStreamHandlerFactory = stream.handlerFactory();
        handlerFactory.setEnvironment({
            recordHandler: '',
            dynamoTableName: this._resource.tableName,
        });
        let streamHandler: IStreamHandler = handlerFactory.createHandler();
        streamHandler.addEventSource(stream.eventSource());
    }

    put(record: I): void {

    }

    eventSource(): lambda.IEventSource {
        return new DynamoEventSource(this.resource, {
            batchSize: 100,
            startingPosition: lambda.StartingPosition.TRIM_HORIZON
          });
    }

    handlerFactory(): IStreamHandlerFactory {
        return new NodeJsLambdaKinesisStreamHandlerFactory(this._stack);
    }
}
 