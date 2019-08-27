FROM ubuntu:18.10

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get -y upgrade && apt-get -y install curl wget gnupg && rm -rf /var/lib/apt/lists/*
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -

RUN echo "deb http://apt.llvm.org/cosmic/ llvm-toolchain-cosmic-6.0 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/cosmic/ llvm-toolchain-cosmic-6.0 main" >> /etc/apt/sources.list


#    curl http://releases.llvm.org/6.0.1/llvm-6.0.1.src.tar.xz --output llvm.tar.xz && \
#    tar -xf llvm.tar.xz -C . && \
#    rm llvm.tar.xz && \
#    cd llvm-6.0.1.src && mkdir -v build && cd /llvm-6.0.1.src/build && \
#    cmake -DCMAKE_INSTALL_PREFIX=/usr           \
#      -DLLVM_ENABLE_FFI=ON                      \
#      -DCMAKE_BUILD_TYPE=Release                \
#      -DLLVM_BUILD_LLVM_DYLIB=ON                \
#      -DLLVM_LINK_LLVM_DYLIB=ON                 \
#      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
#      -DLLVM_BUILD_TESTS=Off                    \
#      -DLLVM_ENABLE_RTTI=On			\
#      -Wno-dev -G Ninja .. && ninja -j2 && ninja install && \
#      cd / && \
#      rm -r llvm-6.0.1.src && \


RUN apt-get update && \
    apt-get -y install tar xz-utils cmake ninja-build build-essential libffi-dev python libboost1.67-all-dev git libssl-dev libncurses5-dev \
               python-pip radare2 time pandoc python3-setuptools python3-pip python3-tempita clang-7 lldb-7 lld-7 llvm-7 python-matplotlib glpk-utils libglpk-dev glpk-doc&& \
    rm -rf /var/lib/apt/lists/* && \
      mkdir -p /home/sip/ && \
      cd /home/sip/ && git clone https://github.com/nlohmann/json.git && mkdir -p /home/sip/json/build/ && cd /home/sip/json/build/ && cmake -DJSON_BuildTests=Off --config=Release .. && make && make install && cd /home/sip && rm -rf /home/sip/json/ && \
    pip install argparse numpy pandas r2pipe pwn benchexec pypandoc && \
    wget https://github.com/sosy-lab/benchexec/releases/download/1.16/benchexec_1.16-1_all.deb && dpkg -i benchexec_*.deb && rm benchexec_*.deb
    
WORKDIR /
RUN curl http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz --output lemon.tar.gz && \
    tar -xvzf lemon.tar.gz -C . && mkdir -p /lemon-1.3.1/build && cd /lemon-1.3.1/build && \
    sed -i '6i SET(CMAKE_POSITION_INDEPENDENT_CODE ON)' /lemon-1.3.1/CMakeLists.txt
RUN cd /lemon-1.3.1/build && cmake .. && make -j4 && make install

WORKDIR /home/sip
RUN git clone https://github.com/mr-ma/composition-function-filter.git function-filter && mkdir -p /home/sip/function-filter/build && cd /home/sip/function-filter/build && cmake --config=Release .. && make -j4 && make install 
RUN git clone https://github.com/mr-ma/composition-framework.git && mkdir -p /home/sip/composition-framework/build && cd /home/sip/composition-framework/build && cmake --config=Release .. && make -j4 && make install

#ADD composition-framework/ /home/sip/composition-framework/
#ADD self-checksumming/ /home/sip/self-checksumming/
#ADD sip-oblivious-hashing/ /home/sip/sip-oblivious-hashing/
#ADD sip-control-flow-integrity/ /home/sip/sip-control-flow-integrity/
#ADD code-mobility-mock/ /home/sip/code-mobility-mock/
#ADD input-dependency-analyzer/ /home/sip/input-dependency-analyzer/
#ADD dg/ /home/sip/dg/
#ADD eval/ /home/sip/eval/
#ADD CMakeLists.txt /home/sip/CMakeLists.txt
#mkdir -p /home/sip/build && cd /home/sip/build && cmake --config=Release .. && make -j4 && make install && \
#mkdir -p /home/sip/code-mobility-mock/build && cd /home/sip/code-mobility-mock/build && cmake --config=Release .. && make -j4 && \


RUN git clone https://github.com/mr-ma/composition-input-dependency-analyzer.git input-dependency-analyzer && mkdir -p /home/sip/input-dependency-analyzer/build && cd /home/sip/input-dependency-analyzer/build && cmake --config=Release .. && make -j4 && make install

RUN git clone https://github.com/tum-i22/dg.git && mkdir -p /home/sip/dg/build && cd /home/sip/dg/build && cmake --config=Release .. && make -j4 && make install 


RUN git clone https://github.com/mr-ma/composition-self-checksumming.git self-checksumming && mkdir -p /home/sip/self-checksumming/build && cd /home/sip/self-checksumming/build && cmake --config=Debug .. && make -j4 && make install
RUN git clone https://github.com/mr-ma/composition-sip-oblivious-hashing.git sip-oblivious-hashing && mkdir -p /home/sip/sip-oblivious-hashing/build && cd /home/sip/sip-oblivious-hashing/build && cmake --config=Release .. && make -j4
RUN git clone https://github.com/mr-ma/composition-sip-control-flow-integrity.git sip-control-flow-integrity && mkdir -p /home/sip/sip-control-flow-integrity/build && cd /home/sip/sip-control-flow-integrity/build && cmake --config=Release .. && make -j4
RUN git clone https://github.com/mr-ma/composition-sip-eval.git eval && mkdir -p /home/sip/eval/passes/build && cd /home/sip/eval/passes/build && cmake --config=Release .. && make -j4
RUN cd /home/sip/self-checksumming/hook && make -j4

WORKDIR /home/sip/eval

CMD ["/bin/bash"]
