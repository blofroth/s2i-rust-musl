# Usage in OpenShift

While this S2I builder image can be used simply with the `s2i` tool it is also quite
suitable to use in an OpenShift environment

# A complete template example
This template creates a whole OpenShift setup for a Rust application built with Cargo.

Import the template in OpenShift:

    https://raw.githubusercontent.com/blofroth/s2i-rust-musl/master/oc/app-template.yaml

Either in the web console:

  1. "Add to Project", then
  2. "Import YAML / JSON"
  3. Paste the complete template from the URL above
  4. Select both "Process the template" and "Save the template" (if you need it for more apps)
  5. Fill in the parameters relevant to your Rust application
  6. Possibly do some after adjustment of the DeployConfig or the created Route to suit your setup.
  7. Start the `${APP}-artifact-build"` build, which should build everything and deploy two
       instances of the built server.

Or on the commandline:

    oc create -f https://raw.githubusercontent.com/blofroth/s2i-rust-musl/master/oc/app-template.yaml


The default values should work to deploy the example project:

    https://github.com/blofroth/pipedream

# As an S2I builder image

Import the builder image as an image stream definition:

    https://raw.githubusercontent.com/blofroth/s2i-rust-musl/master/oc/image

# Resources

* [OpenShift Origin 3.6 documentation](https://docs.openshift.org/3.6/welcome/index.html)