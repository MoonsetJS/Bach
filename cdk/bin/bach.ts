#!/usr/bin/env node
import cdk = require('@aws-cdk/core');
import { BachStack } from '../lib/bach-stack';

const app = new cdk.App();
new BachStack(app, 'BachStack');