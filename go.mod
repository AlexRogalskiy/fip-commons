module github.com/sighupio/fip-commons

go 1.16

require (
	github.com/konsorten/go-windows-terminal-sequences v1.0.3 // indirect
	github.com/sirupsen/logrus v1.8.3
	k8s.io/api v0.18.14
	k8s.io/apimachinery v0.18.14
	k8s.io/client-go v0.18.4
)

replace k8s.io/client-go => k8s.io/client-go v0.18.14
