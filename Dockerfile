FROM opensuse:42.1
MAINTAINER Rakkattakka <raman_buthusaim@yahoo.com>

# Install Dependencies
RUN zypper update \
    && zypper install -y curl \
    binutils \
    which \
    git \
    tar \
    libunwind \
    libicu \
    lttng-ust \
    libuuid1 \
    libopenssl1_0_0 \
    libcurl4

# Install mono
RUN zypper install -y mono-complete fsharp mono-nuget

# Install dotnet
RUN mkdir -p /opt/dotnet \
    && curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=843451 \
    && tar zxf dotnet.tar.gz -C /opt/dotnet \
    && ln -s /opt/dotnet/dotnet /usr/local/bin \
    && rm dotnet.tar.gz

# Install nuget
RUN mkdir -p /opt/nuget \
    && curl -Lsfo /opt/nuget/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe

# Prime dotnet
RUN mkdir dotnettest \
    && cd dotnettest \
    && dotnet new mvc --auth None --framework netcoreapp1.1 \
    && dotnet restore \
    && dotnet build \
    && cd .. \
    && rm -r dotnettest

# Display info installed components
RUN mono --version
RUN dotnet --info
