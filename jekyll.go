package main

import (
	"fmt"
	"net"
	"os"
	"strconv"
	"strings"

	"github.com/spf13/cobra"
)

var (
	protocol string
	host     string
	port     int
	version  = "0.0.1"
)

func main() {
	jekyll := &cobra.Command{
		Use:     "Jekyll",
		Short:   "Jekyll is a simple port probing application written in Go.",
		Version: version,
		Run: func(cmd *cobra.Command, args []string) {
			switch strings.ToLower(protocol) {
			case "tcp":
			case "udp":
			default:
				fmt.Println("Protocol has to be TCP or UDP.")
				os.Exit(1)
			}

			if port < 0 || port > 65535 {
				fmt.Println("Port has to be between 0 and 65535.")
				os.Exit(1)
			}

			connection, exception := net.Dial(protocol, net.JoinHostPort(host, strconv.Itoa(port)))
			if exception != nil {
				fmt.Println(exception)
				os.Exit(1)
			}
			_ = connection.Close()
			os.Exit(0)
		},
	}

	jekyll.Flags().StringVarP(&protocol, "protocol", "p", "tcp", "protocol to check")
	jekyll.Flags().StringVarP(&host, "host", "H", "127.0.0.1", "host to check")
	jekyll.Flags().IntVarP(&port, "port", "P", 80, "port to check")

	jekyll.SetVersionTemplate("{{.Version}}\n")

	exception := jekyll.Execute()
	if exception != nil {
		fmt.Println(exception)
		os.Exit(1)
	}
}
