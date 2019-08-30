# sip-shaker-artifact
This repository contains the artifacts of our paper at ACSAC'2019.
Honoring ACSAC's initiative, we have decided upon releasing both software and data of our work.


## Dockerized Approach

### Setting up Testbed

Build a docker image using the provided [DockerFile](https://github.com/mr-ma/sip-shaker-artifact/blob/master/Dockerfile).
Run docker container with the following parameters:
```docker run -v /sys/fs/cgroup:/sys/fs/cgroup:rw --security-opt seccomp=unconfined {IMAGEID/IMAGENAME}```

Please note that our performance measurements are done using [benchexec](https://github.com/sosy-lab/benchexec) tool which relies on cgroup access. Therefore, you need to make sure that your docker container has r/w access permission to the host's cgroup.  



### Dataset
In the docker container `eval/local_dataset` contains bitcode files for the 19 programs that were used in our evaluations.
The same directory can be found in the [composition-sip-eval](https://github.com/mr-ma/composition-sip-eval) repository.


### Running Experiment
In our work we conducted two experiments: coverage optimization (section 6.4) and performance evaluation (section 6.5).

***IMPORTANT: All the scripts can be found in the eval directory.***

```cd eval```

#### Section 6.4
Execute ```bash run-6.4.sh```

Results will be dumped in ```ilp_optimization_results.csv```

#### Section 6.5
Run ```bash run-6.5.sh```

Results will be dumped in ```performance-evaluation-combined-percentage.pdf```

## Manual Approach
We recommend the dockerized approach. Interested users, can build the entire toolchain manually. 

### Protection Passes
1. [Oblivious Hashing and Short Short Oblivious Hashing](https://github.com/mr-ma/composition-sip-oblivious-hashing)
2. [Self-Checksumming](https://github.com/mr-ma/composition-self-checksumming)
3. [Control Flow Integrity](https://github.com/mr-ma/composition-sip-control-flow-integrity)

### Utility Passes
1. Partial Protection Pass, i.e. [Filter Function](https://github.com/mr-ma/composition-function-filter)
2. [Inter-procedural dependency analyzer](https://github.com/mr-ma/composition-input-dependency-analyzer)
3. [Dependency Graph (external)](https://github.com/tum-i22/dg)
4. [Code Mobility Mock](https://github.com/mr-ma/composition-code-mobility-mock)


### Composition Framework
[SIP SHAKER Framework](https://github.com/mr-ma/composition-framework)

### Evaluation Benchmark
[SIP Evaluation](https://github.com/mr-ma/composition-sip-eval)
