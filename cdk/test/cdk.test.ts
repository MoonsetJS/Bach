import { expect as expectCDK, haveResource } from '@aws-cdk/assert';
import cdk = require('@aws-cdk/core');
import Cdk = require('../lib/bach-stack');

test('Kinesis Stream Created', () => {
    const app = new cdk.App();
    // WHEN
    const stack = new Cdk.BachStack(app, 'MyTestStack');
    // THEN
    expectCDK(stack).to(haveResource("AWS::Kinesis::Stream",{
      ShardCount: 2,
      RetentionPeriodHours: 48
    }));
});

test('DynamoDB Table Created', () => {
  const app = new cdk.App();
  // WHEN
  const stack = new Cdk.BachStack(app, 'MyTestStack');
  // THEN
  expectCDK(stack).to(haveResource("AWS::DynamoDB::Table"));
});